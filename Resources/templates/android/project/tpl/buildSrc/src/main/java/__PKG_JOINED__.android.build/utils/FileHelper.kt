/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import org.json.JSONObject
import java.io.File

fun addObjectToJsonFile(path: String, name: String, value: Int) {
    val file = File(path)
    if (file.exists()) {
        val jsonString = file.readFile()
        val jsonObj: JSONObject = retrieveJSONObject(jsonString)
        jsonObj.put(name, value)
        file.writeText(jsonObj.toString(2))
    }
}

fun assetsPath(): String =
    APP_PATH_KEY + File.separator + SRC_PATH_KEY + File.separator + MAIN_PATH_KEY +
            File.separator + ASSETS_PATH_KEY

fun getCatalogPath(tableName: String): String = assetsPath() + File.separator + XCASSETS_PATH_KEY +
        File.separator + CATALOG_PATH_KEY + File.separator +
        "$tableName.${CATALOG_DATASET_SUFFIX}" + File.separator +
        "$tableName.${CATALOG_JSON_SUFFIX}"

fun getDataPath(tableName: String): String = assetsPath() + File.separator + XCASSETS_PATH_KEY +
        File.separator + DATA_PATH_KEY + File.separator +
        "$tableName.$DATA_DATASET_SUFFIX" + File.separator +
        "$tableName.$DATA_JSON_SUFFIX"

fun getAppinfoPath(): String = assetsPath() + File.separator + APPINFO_FILENAME