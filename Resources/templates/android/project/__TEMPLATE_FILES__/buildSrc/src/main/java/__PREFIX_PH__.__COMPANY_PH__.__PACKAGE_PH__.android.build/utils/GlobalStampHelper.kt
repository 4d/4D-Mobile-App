/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.android.build.utils

fun integrateGlobalStamp(initialGlobalStamp: Int) {
    val appInfoPath = getAppinfoPath()
    println("Updating initialGlobalStamp value in appinfo.json file with value $initialGlobalStamp")
    addObjectToJsonFile(appInfoPath, INITIAL_GLOBALSTAMP_KEY, initialGlobalStamp)
}