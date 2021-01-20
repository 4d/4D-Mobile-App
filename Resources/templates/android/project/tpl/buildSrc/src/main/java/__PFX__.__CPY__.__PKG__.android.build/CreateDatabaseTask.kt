/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.android.build

import {{prefix}}.{{company}}.{{app_name}}.android.build.database.SqlQuery
import {{prefix}}.{{company}}.{{app_name}}.android.build.database.StaticDataInitializer
import {{prefix}}.{{company}}.{{app_name}}.android.build.database.StaticDatabase
import {{prefix}}.{{company}}.{{app_name}}.android.build.model.Field
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.*
import org.gradle.api.DefaultTask
import org.gradle.api.tasks.InputFile
import org.gradle.api.tasks.OutputFile
import org.gradle.api.tasks.TaskAction
import java.io.File

open class CreateDatabaseTask : DefaultTask() {

    private val tableNames = arrayOf({{#tableNames}}"{{name}}"{{^-last}}, {{/-last}}{{/tableNames}})

    private var initialGlobalStamp = 0

    @get:OutputFile
    lateinit var dbFile: File

    @get:InputFile
    lateinit var schema: File

    @TaskAction
    fun update() {
        dbFile.delete()

        StaticDatabase.initialize(dbFile, schema, logger, tableNames).useInTransaction { database ->

            val staticDataInitializer = StaticDataInitializer()

            database.insertAll(getSqlQueries(staticDataInitializer))
            logger.lifecycle("Database updated")
            integrateGlobalStamp(initialGlobalStamp)
        }
    }

    private fun getSqlQueries(staticDataInitializer: StaticDataInitializer): List<SqlQuery> {
        val queryList = mutableListOf<SqlQuery>()
        for (tableName in tableNames) {
            getCatalog(tableName)?.let { dataClass ->

                getSqlQueriesForTable(
                    tableName,
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
        fields: List<Field>,
        staticDataInitializer: StaticDataInitializer
    ): SqlQuery? {

        val filePath = getDataPath(tableName)

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

                    println("[$tableName] ${sqlQueryBuilder.outputEntities.size} entities extracted")

                    return staticDataInitializer.getQuery(
                        tableName,
                        sqlQueryBuilder.propertyNameList,
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