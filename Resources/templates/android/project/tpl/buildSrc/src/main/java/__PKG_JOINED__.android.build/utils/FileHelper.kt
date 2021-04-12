/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build.utils

import org.json.JSONObject
import java.io.File
import java.text.Normalizer

fun addToAppinfo(key: String, value: Any) {
    getAppinfoFile()?.let { file ->
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

private fun getAppinfoPath(): String = assetsPath() + File.separator + APPINFO_FILENAME

private fun getAppinfoFile(): File? {
    val file = File(getAppinfoPath())
    if (file.exists()) {
        return file
    }
    println("Appinfo.json file does not exists : ${file.absolutePath}")
    return null
}

/**
 * Field / Table name adjustments
 */

private fun String.condense() = this.replace("\\s".toRegex(), "")

fun String.fieldAdjustment() = this.condense().replaceSpecialChars().validateWord()

private fun String.replaceSpecialChars(): String {
    return if (this.contains("Entities<")) {
        this.unaccent().replace("[^a-zA-Z0-9._<>]".toRegex(), "_")
    } else {
        this.unaccent().replace("[^a-zA-Z0-9._]".toRegex(), "_")
    }
}

private val REGEX_UNACCENT = "\\p{InCombiningDiacriticalMarks}+".toRegex()

fun CharSequence.unaccent(): String {
    val temp = Normalizer.normalize(this, Normalizer.Form.NFD)
    return REGEX_UNACCENT.replace(temp, "")
}

private const val prefixReservedKeywords = "qmobile"

fun String.validateWord(): String =
    if (reservedKeywords.contains(this)) "${prefixReservedKeywords}_$this" else this

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
