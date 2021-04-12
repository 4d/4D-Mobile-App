/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import org.json.JSONArray

fun integrateGlobalStamp(initialGlobalStamp: Int) {
    println("Updating initialGlobalStamp value in appinfo.json file with value $initialGlobalStamp")
    addToAppinfo(INITIAL_GLOBALSTAMP_KEY, initialGlobalStamp)
}

fun integrateDumpedTables(tableNames: List<String>) {
    println("Updating dumpedTables value in appinfo.json file with value ${tableNames.joinToString()}")
    addToAppinfo(DUMPED_TABLES_KEY, JSONArray(tableNames))
}
