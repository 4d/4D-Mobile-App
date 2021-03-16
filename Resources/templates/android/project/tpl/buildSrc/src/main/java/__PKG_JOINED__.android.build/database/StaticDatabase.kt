/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.database

import {{package}}.android.build.utils.DRIVER_CLASSNAME
import {{package}}.android.build.utils.SQL_DB_URL_PREFIX
import {{package}}.android.build.utils.closureOf
import groovy.sql.Sql
import org.apache.commons.io.IOUtils
import org.gradle.api.logging.Logger
import org.json.JSONObject
import java.io.Closeable
import java.io.File

class StaticDatabase private constructor(
    private val sql: Sql,
    private val logger: Logger,
    private val tableNames: Array<String>
) : Closeable {

    fun insertAll(queryList: List<SqlQuery>) {
        queryList.forEach { insert(it) }
    }

    private fun insert(queryProvider: SqlQuery) {
        queryProvider.parameters.forEach {
            sql.executeInsert(queryProvider.query, it)
        }
    }

    private fun logTableCount(name: String) {
        val count = sql.firstRow("SELECT count(*) FROM $name", arrayListOf()).toString()
        logger.lifecycle("$name: $count")
    }

    override fun close() {
        tableNames.forEach {
            logTableCount(it)
        }
        sql.close()
    }

    companion object {
        private fun openSQL(dbFile: File, schemaFile: File, logger: Logger) =
            Sql.newInstance("$SQL_DB_URL_PREFIX:$dbFile", DRIVER_CLASSNAME).apply {
                val schema = JSONObject(IOUtils.toString(schemaFile.reader()))
                schema.getJSONObject("database")
                    .optJSONArray("entities")
                    ?.filterIsInstance(JSONObject::class.java)
                    ?.forEach {
                        // only main createSql script is needed, others are being executed by Room on
                        // first init (indices for example)
                        val tableName = it.getString("tableName")
                        logger.lifecycle("Creating table $tableName")
                        val sql = it.getString("createSql").replace("\${TABLE_NAME}", tableName)
                        logger.debug(sql)
                        execute(sql)
                    }
            }

        fun initialize(dbFile: File, schemaFile: File, logger: Logger, tableNames: Array<String>) =
            StaticDatabase(openSQL(dbFile, schemaFile, logger), logger, tableNames)
    }

    fun <R> useInTransaction(block: (StaticDatabase) -> R) = use {
        sql.withTransaction(closureOf<Any> {
            block(this@StaticDatabase)
        })
    }
}