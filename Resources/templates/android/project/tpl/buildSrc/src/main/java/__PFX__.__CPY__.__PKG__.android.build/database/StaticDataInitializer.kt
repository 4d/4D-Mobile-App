/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.android.build.database

data class SqlQuery(val query: String, val parameters: List<Array<out Any?>>)

class StaticDataInitializer {

    fun getQuery(
        tableName: String,
        propertyNameList: List<String>,
        results: ArrayList<Array<Any?>>
    ): SqlQuery? {
        return SqlQuery(
            "INSERT INTO $tableName (${propertyNameList.joinToString()}) VALUES (${propertyNameList.joinToString { "?" }})",
            results
        )
    }
}