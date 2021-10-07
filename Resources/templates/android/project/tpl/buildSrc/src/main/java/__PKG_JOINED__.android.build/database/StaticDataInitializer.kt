/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.database

data class SqlQuery(val query: String, var parameters: List<Array<out Any?>>, val tableName: String)

class StaticDataInitializer {

    fun getQuery(
        tableName: String,
        propertyNameList: List<String>,
        results: ArrayList<Array<Any?>>
    ): SqlQuery {
        return SqlQuery(
            "INSERT INTO $tableName (${propertyNameList.joinToString()}) VALUES (${propertyNameList.joinToString { "?" }})",
            results,
            tableName
        )
    }
}