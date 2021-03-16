/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.io.File

fun JSONObject.getSafeArray(key: String): JSONArray? {
    return try {
        this.getJSONArray(key)
    } catch (e: JSONException) {
        return null
    }
}

fun JSONObject.getSafeInt(key: String): Int? {
    return try {
        this.getInt(key)
    } catch (e: JSONException) {
        return null
    }
}

fun JSONObject.getSafeString(key: String): String? {
    return try {
        this.getString(key)
    } catch (e: JSONException) {
        return null
    }
}

fun File.readFile(): String {
    return this.bufferedReader().use {
        it.readText()
    }
}

fun JSONObject.getSafeObject(key: String): JSONObject? {
    return try {
        this.getJSONObject(key)
    } catch (e: JSONException) {
        return null
    }
}

fun JSONObject.getSafeBoolean(key: String): Boolean? {
    return try {
        this.getBoolean(key)
    } catch (e: JSONException) {
        return null
    }
}

fun retrieveJSONObject(jsonString: String): JSONObject =
    JSONObject(jsonString.substring(jsonString.indexOf("{"), jsonString.lastIndexOf("}") + 1))