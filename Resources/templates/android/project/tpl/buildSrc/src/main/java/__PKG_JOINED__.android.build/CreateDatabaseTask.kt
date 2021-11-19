/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build

import {{package}}.android.build.database.SqlQuery
import {{package}}.android.build.database.StaticDataInitializer
import {{package}}.android.build.database.StaticDatabase
import {{package}}.android.build.model.DataClass
import {{package}}.android.build.model.Field
import {{package}}.android.build.utils.*
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.InputFile
import org.gradle.api.tasks.OutputFile
import org.gradle.api.tasks.TaskAction
import org.json.JSONObject
import java.io.File

open class CreateDatabaseTask : DefaultTask() {

    private val tableNames: Map<String, String> = 
        mapOf({{#tableNames}}"{{name}}" to "{{name_original}}"{{^-last}}, {{/-last}}{{/tableNames}})

    private val propertyListMap = mutableMapOf<String, List<String>>()
    private val relatedEntitiesMapList =
        mutableListOf<MutableMap<String, MutableList<JSONObject>>>()
    private val dataClassList = mutableListOf<DataClass>()

    private var initialGlobalStamp = 0
    private val dumpedTables = mutableListOf<String>()

    @get:OutputFile
    lateinit var dbFile: File

    @get:InputFile
    lateinit var schema: File

    @TaskAction
    fun update() {
        dbFile.delete()

        StaticDatabase.initialize(dbFile, schema, logger, tableNames.keys.toTypedArray()).useInTransaction { database ->

            val staticDataInitializer = StaticDataInitializer()

            database.insertAll(getSqlQueries(staticDataInitializer))
            logger.lifecycle("Database updated")
            integrateGlobalStamp(initialGlobalStamp)
            integrateDumpedTables(dumpedTables)
        }
    }

    private fun getSqlQueries(staticDataInitializer: StaticDataInitializer): List<SqlQuery> {
        val queryList = mutableListOf<SqlQuery>()
        for ((tableName, tableNameOriginal) in tableNames) {
            getCatalog(tableNameOriginal)?.let { dataClass ->

                queryList.addAll(
                    getSqlQueriesForTable(
                        tableName,
                        tableNameOriginal,
                        dataClass.fields,
                        staticDataInitializer
                    )
                )
                
                dataClassList.add(dataClass)
            }
        }
        queryList.addAll(getSqlQueriesForRelatedTables(staticDataInitializer))

        return filterUnique(queryList)
    }

    private fun filterUnique(queries: MutableList<SqlQuery>): MutableList<SqlQuery> {

        val newQueries = mutableListOf<SqlQuery>()

        queries.forEach { sqlQuery ->

            var keyPropertyIndex = propertyListMap[sqlQuery.tableName]?.indexOf("__KEY") ?: 0
            if (keyPropertyIndex == -1) keyPropertyIndex = 0

            sqlQuery.parameters.forEach { array ->
                val key = array[keyPropertyIndex]
                key?.let {
                    val siblingQueries = queries
                        .filter { it.query == sqlQuery.query } // all queries for the same table

                    val newArray = arrayOfNulls<Any>(array.size)
                    array.indices.forEach { index ->
                        newArray[index] = array[index]
                        siblingQueries.forEach { siblingQuery ->

                            siblingQuery.parameters.forEach { arr -> // each line of parameters (one entity)
                                if (arr[keyPropertyIndex] == key && newArray[index] == null) {
                                    newArray[index] = arr[index]
                                }
                            }
                        }
                    }

                    val newQuery = SqlQuery(sqlQuery.query, listOf(newArray), sqlQuery.tableName)
                    if (newQueries
                            .filter { it.query == newQuery.query }
                            .firstOrNull {
                                it.parameters.firstOrNull()?.get(keyPropertyIndex) == key
                            } == null
                    ) {
                        newQueries.add(newQuery)
                    }
                }
            }
        }
        return newQueries
    }

    private fun getSqlQueriesForRelatedTables(staticDataInitializer: StaticDataInitializer): List<SqlQuery> {
        val queryList = mutableListOf<SqlQuery>()
        relatedEntitiesMapList.forEach { relatedEntitiesMap ->
            for ((originalTableName, jsonEntityList) in relatedEntitiesMap) {
                val tableName =
                    tableNames.filter { it.value == originalTableName }.keys.firstOrNull()
                val relatedTableFields = dataClassList.find { it.name == originalTableName }?.fields
                if (tableName != null && relatedTableFields != null) {

                    jsonEntityList.forEach { jsonEntity ->

                        val sqlQueryBuilder = SqlQueryBuilder(jsonEntity, relatedTableFields)
                        
                        queryList.add(
                            getQueryFromSqlQueryBuilder(
                                sqlQueryBuilder,
                                tableName,
                                staticDataInitializer
                            )
                        )
                    }
                }
            }
        }
        return queryList
    }

    private fun getSqlQueriesForTable(
        tableName: String,
        tableNameOriginal: String,
        fields: List<Field>,
        staticDataInitializer: StaticDataInitializer
    ): List<SqlQuery> {

        val sqlQueryList = mutableListOf<SqlQuery>()

        val filePath = getDataPath(tableNameOriginal)
        val entitySqlQueriesFile = File(filePath)

        println("[$tableName] Reading data at path $filePath")

        if (entitySqlQueriesFile.exists()) {
            getSqlQueriesForTableFromFile(
                tableName,
                entitySqlQueriesFile,
                fields,
                staticDataInitializer
            )?.let {
                sqlQueryList.add(it)
            }
        } else {
            println("[$tableName] No data file found")
        }

        var i = 0
        do {
            val pageFilePath = getDataPath(tableNameOriginal, ++i)
            val pageEntitySqlQueriesFile = File(pageFilePath)

            println("[$tableName] Reading data at path $pageFilePath")

            if (pageEntitySqlQueriesFile.exists()) {
                getSqlQueriesForTableFromFile(
                    tableName,
                    pageEntitySqlQueriesFile,
                    fields,
                    staticDataInitializer
                )?.let {
                    sqlQueryList.add(it)
                }
            } else {
                println("[$tableName] No data file found")
            }
        } while (pageEntitySqlQueriesFile.exists())

        return sqlQueryList
    }

    private fun getSqlQueriesForTableFromFile(
        tableName: String,
        entitySqlQueriesFile: File,
        fields: List<Field>,
        staticDataInitializer: StaticDataInitializer
    ): SqlQuery? {

        val jsonString = entitySqlQueriesFile.readFile()

        if (jsonString.isNotEmpty()) {
            val jsonObj = retrieveJSONObject(jsonString)
            val entities = jsonObj.getSafeArray("__ENTITIES")

            jsonObj.getSafeInt("__GlobalStamp")?.let { globalStamp ->
                dumpedTables.add(tableName)
                if (globalStamp > initialGlobalStamp) initialGlobalStamp = globalStamp
            }

            entities?.let {
                val sqlQueryBuilder = SqlQueryBuilder(it, fields)

                relatedEntitiesMapList.add(sqlQueryBuilder.relatedEntitiesMap)

                return getQueryFromSqlQueryBuilder(
                    sqlQueryBuilder,
                    tableName,
                    staticDataInitializer
                )
            }

            println("[$tableName] Couldn't find entities to extract")

        } else {
            println("[$tableName] Empty data file")
        }

        return null
    }

    private fun getQueryFromSqlQueryBuilder(
        sqlQueryBuilder: SqlQueryBuilder,
        tableName: String,
        staticDataInitializer: StaticDataInitializer
    ): SqlQuery {

        val propertyList = sqlQueryBuilder.hashMap.toSortedMap().keys.toList()
        propertyListMap[tableName] = propertyList

        println("[$tableName] ${sqlQueryBuilder.outputEntities.size} entities extracted")

        return staticDataInitializer.getQuery(
            tableName,
            propertyList,
            sqlQueryBuilder.outputEntities
        )
    }
}