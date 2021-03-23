/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.database

data class SqlQuery(val query: String, val parameters: List<Array<out Any?>>)

class StaticDataInitializer {

    fun getQuery(
        tableName: String,
        propertyNameList: List<String>,
        results: ArrayList<Array<Any?>>
    ): SqlQuery? {
        
        results.forEach { arr ->
            println("INSERT INTO $tableName (${propertyNameList.joinToString()}) VALUES (${propertyNameList.joinToString { "?" }})")
            println("> VALUES : ${arr.joinToString()}")
            println()
        }
        return SqlQuery(
            "INSERT INTO $tableName (${propertyNameList.joinToString()}) VALUES (${propertyNameList.joinToString { "?" }})",
            results
        )
    }
}