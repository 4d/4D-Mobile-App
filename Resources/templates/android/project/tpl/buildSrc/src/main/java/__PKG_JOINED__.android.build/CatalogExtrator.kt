/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build

import {{package}}.android.build.model.DataClass
import {{package}}.android.build.model.Field
import {{package}}.android.build.utils.fieldAdjustment
import {{package}}.android.build.utils.getCatalogPath
import {{package}}.android.build.utils.getSafeArray
import {{package}}.android.build.utils.getSafeString
import {{package}}.android.build.utils.readFile
import {{package}}.android.build.utils.retrieveJSONObject
import java.io.File

{{#tableNames}}
val fields{{name}} = listOf<String>({{{concat_fields}}})
{{/tableNames}}

fun getCatalog(tableName: String): DataClass? {

    val filePath = getCatalogPath(tableName)

    println("[$tableName] Reading catalog at path $filePath")

    val entityCatalogFile = File(filePath)

    if (entityCatalogFile.exists()) {
        val jsonString = entityCatalogFile.readFile()

        if (jsonString.isNotEmpty()) {
            val jsonObj = retrieveJSONObject(jsonString)
            val dataClasses = jsonObj.getSafeArray("dataClasses")
            dataClasses?.getJSONObject(0)?.let { jsonDataClass ->
                jsonDataClass.getSafeString("name")?.let { dataClassName ->
                    println("dataClassName = $dataClassName")

                    jsonDataClass.getSafeArray("attributes")?.let { attributes ->

                        val fields = mutableListOf<Field>()

                        for (i in 0 until attributes.length()) {

                            val attribute = attributes.getJSONObject(i)

                            attribute.getSafeString("name")?.let { fieldName ->

                                if (isFieldDefined(dataClassName, fieldName)) {

                                    val field = Field(fieldName.fieldAdjustment())
                                    attribute.getSafeString("type")
                                        ?.let { type -> field.isImage = type == "image" }
                                    attribute.getSafeString("kind")?.let { kind ->
                                        when (kind) {
                                            "relatedEntity" -> field.isManyToOneRelation = true
                                            "relatedEntities" -> field.isOneToManyRelation = true
                                        }
                                    }
                                    fields.add(field)
                                } else {
                                    println("Field is not defined : $fieldName")
                                }
                            }
                        }

                        println("[$tableName] Catalog successfully read")
                        return DataClass(name = dataClassName, fields = fields)
                    }
                }
            }
            println("[$tableName] Catalog json is missing name or attributes keys")
        } else {
            println("[$tableName] Empty catalog file")
        }
    } else {
        println("[$tableName] No catalog file found")
    }
    return null
}

fun isFieldDefined(tableName: String, fieldName: String): Boolean {
    return when (tableName) {
        {{#tableNames}}
        "{{name_original}}" -> fields{{name}}.contains(fieldName)
        {{/tableNames}}
        else -> false
    }
}