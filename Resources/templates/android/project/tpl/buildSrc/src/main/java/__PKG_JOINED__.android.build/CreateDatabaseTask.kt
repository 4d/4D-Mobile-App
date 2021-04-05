/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build

import {{package}}.android.build.database.SqlQuery
import {{package}}.android.build.database.StaticDataInitializer
import {{package}}.android.build.database.StaticDatabase
import {{package}}.android.build.model.Field
import {{package}}.android.build.utils.*
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.InputFile
import org.gradle.api.tasks.OutputFile
import org.gradle.api.tasks.TaskAction
import java.io.File

open class CreateDatabaseTask : DefaultTask() {

    private val tableNames = 
        mapOf<String, String>({{#tableNames}}"{{name}}" to "{{name_original}}"{{^-last}}, {{/-last}}{{/tableNames}})

    private var initialGlobalStamp = 0

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
        }
    }

    private fun getSqlQueries(staticDataInitializer: StaticDataInitializer): List<SqlQuery> {
        val queryList = mutableListOf<SqlQuery>()
        for ((tableName, tableNameOriginal) in tableNames) {
            getCatalog(tableNameOriginal)?.let { dataClass ->

                getSqlQueriesForTable(
                    tableName,
                    tableNameOriginal,
                    dataClass.fields,
                    staticDataInitializer
                )?.let { sqlQuery ->
                    queryList.add(sqlQuery)
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
    ): SqlQuery? {

        val filePath = getDataPath(tableNameOriginal)

        println("[$tableName] Reading data at path $filePath")

        val entitySqlQueriesFile = File(filePath)
        if (entitySqlQueriesFile.exists()) {

            val jsonString = entitySqlQueriesFile.readFile()

            if (jsonString.isNotEmpty()) {
                val jsonObj = retrieveJSONObject(jsonString)
                val entities = jsonObj.getSafeArray("__ENTITIES")
                jsonObj.getSafeInt("__GlobalStamp")?.let { globalStamp ->
                    if (globalStamp > initialGlobalStamp) initialGlobalStamp = globalStamp
                }

                entities?.let {
                    val sqlQueryBuilder = SqlQueryBuilder(it, fields)

                    val propertyList = sqlQueryBuilder.hashMap.toSortedMap().keys.toList()

                    println("[$tableName] ${sqlQueryBuilder.outputEntities.size} entities extracted")

                    return staticDataInitializer.getQuery(
                        tableName,
                        propertyList,
                        sqlQueryBuilder.outputEntities
                    )
                }
                println("[$tableName] Couldn't find entities to extract")
            } else {
                println("[$tableName] Empty data file")
            }
        } else {
            println("[$tableName] No data file found")
        }
        return null
    }
}