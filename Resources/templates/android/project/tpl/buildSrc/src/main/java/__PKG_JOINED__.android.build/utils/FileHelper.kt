/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import org.json.JSONObject
import java.io.File
import java.text.Normalizer
import java.util.*

fun addToAppinfo(key: String, value: Any) {
    getAppInfoFile()?.let { file ->
        val jsonObj: JSONObject = retrieveJSONObject(file.readFile())
        jsonObj.put(key, value)
        file.writeText(jsonObj.toString(2))
    }
}

private fun assetsPath(): String =
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

private fun getAppInfoPath(): String = assetsPath() + File.separator + APP_INFO_FILENAME

private fun getAppInfoFile(): File? {
    val file = File(getAppInfoPath())
    if (file.exists()) {
        return file
    }
    println("app_info.json file does not exists : ${file.absolutePath}")
    return null
}

/**
 * Field / Table name adjustments
 */

private fun String.condense() = this.replace("\\s".toRegex(), "")

fun String.fieldAdjustment() =
    this.condense().replaceSpecialChars().lowerCustomProperties().validateWordDecapitalized()

private fun String.replaceSpecialChars(): String {
    return if (this.contains("Entities<")) {
        this.unaccent().replace("[^a-zA-Z0-9._<>]".toRegex(), "_")
    } else {
        this.unaccent().replace("[^a-zA-Z0-9._]".toRegex(), "_")
    }
}

private fun String.lowerCustomProperties() =
    if (this == "__KEY" || this == "__STAMP" || this == "__GlobalStamp" || this == "__TIMESTAMP")
        this
    else
        if (this.startsWith("__") && this.endsWith("Key"))
            this.removeSuffix("Key").toLowerCase(Locale.getDefault()) + "Key"
        else
            this.toLowerCase(Locale.getDefault())

private fun String.decapitalizeExceptID() = 
    if (this == "ID") this.toLowerCase(Locale.getDefault()) else this.decapitalize(Locale.getDefault())

private val REGEX_UNACCENT = "\\p{InCombiningDiacriticalMarks}+".toRegex()

private fun CharSequence.unaccent(): String {
    val temp = Normalizer.normalize(this, Normalizer.Form.NFD)
    return REGEX_UNACCENT.replace(temp, "")
}

private const val prefixReservedKeywords = "qmobile"

private fun String.validateWordDecapitalized(): String {
    return this.decapitalizeExceptID().split(".").joinToString(".") {
        if (reservedKeywords.contains(it)) "${prefixReservedKeywords}_$it" else it
    }
}

val reservedKeywords = listOf(
    "as",
    "break",
    "class",
    "continue",
    "do",
    "else",
    "false",
    "for",
    "fun",
    "if",
    "in",
    "is",
    "null",
    "object",
    "package",
    "return",
    "super",
    "this",
    "throw",
    "true",
    "try",
    "typealias",
    "typeof",
    "val",
    "var",
    "when",
    "while",
    "by",
    "catch",
    "constructor",
    "delegate",
    "dynamic",
    "field",
    "file",
    "finally",
    "get",
    "import",
    "init",
    "param",
    "property",
    "receiver",
    "set",
    "setparam",
    "where",
    "actual",
    "abstract",
    "annotation",
    "companion",
    "const",
    "crossinline",
    "data",
    "enum",
    "expect",
    "external",
    "final",
    "infix",
    "inline",
    "inner",
    "internal",
    "lateinit",
    "noinline",
    "open",
    "operator",
    "out",
    "override",
    "private",
    "protected",
    "public",
    "reified",
    "sealed",
    "suspend",
    "tailrec",
    "vararg",
    "field",
    "it"
)
