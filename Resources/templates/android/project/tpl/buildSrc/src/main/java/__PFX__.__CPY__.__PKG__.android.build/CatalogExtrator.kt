/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.android.build

import {{prefix}}.{{company}}.{{app_name}}.android.build.model.DataClass
import {{prefix}}.{{company}}.{{app_name}}.android.build.model.Field
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.getCatalogPath
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.getSafeArray
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.getSafeString
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.readFile
import {{prefix}}.{{company}}.{{app_name}}.android.build.utils.retrieveJSONObject
import java.io.File

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
                    jsonDataClass.getSafeArray("attributes")?.let { attributes ->

                        val fields = mutableListOf<Field>()

                        for (i in 0 until attributes.length()) {

                            val attribute = attributes.getJSONObject(i)

                            attribute.getSafeString("name")?.let { fieldName ->
                                val field = Field(fieldName)
                                attribute.getSafeString("type")
                                    ?.let { type -> field.isImage = type == "image" }
                                attribute.getSafeString("kind")?.let { kind ->
                                    when (kind) {
                                        "relatedEntity" -> field.isManyToOneRelation = true
                                        "relatedEntities" -> field.isOneToManyRelation = true
                                    }
                                }
                                fields.add(field)
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