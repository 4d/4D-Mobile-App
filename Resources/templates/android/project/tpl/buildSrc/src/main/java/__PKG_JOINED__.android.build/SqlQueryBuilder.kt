/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build

import {{package}}.android.build.model.Field
import {{package}}.android.build.utils.condenseSpaces
import {{package}}.android.build.utils.getSafeString
import org.json.JSONArray
import org.json.JSONObject

class SqlQueryBuilder(inputEntities: JSONArray, private val fields: List<Field>) {

    val outputEntities = arrayListOf<Array<Any?>>()
    val propertyNameList = mutableListOf<String>()

    init {

        val sampleEntity = inputEntities.getJSONObject(0)
        sampleEntity.keys().forEach { key ->
            propertyNameList.add(key.condenseSpaces())
        }

        for (i in 0 until inputEntities.length()) {

            val inputEntity = inputEntities.getJSONObject(i)

            propertyNameList.clear()
            inputEntity.keys().forEach { key ->
                propertyNameList.add(key.condenseSpaces())
            }

            val outputEntity = extractEntity(inputEntity)
            outputEntities.add(outputEntity)
        }
    }

    private fun extractEntity(inputEntity: JSONObject): Array<Any?> {

        val outputEntity = arrayOfNulls<Any>(propertyNameList.size)
        val associationMap = mutableMapOf<String, Int>() // <propertyName, index>

        var j = 0
        inputEntity.keys().forEach { key ->
            outputEntity[j] = inputEntity[key]

            fields.find { it.name == key }?.let { field ->
                when {
                    field.isImage -> {
                        outputEntity[j] = null
                    }
                    field.isManyToOneRelation -> {

                        // Replacing relation propertyName by __relationKey
                        // This is required in Room to perform relation queries
                        val index = propertyNameList.indexOf(key)
                        propertyNameList[index] = "__${key.condenseSpaces()}Key"
                        associationMap["__${key}Key"] = index
                    }
                    field.isOneToManyRelation -> {
                        // TODO
                    }
                }
            }
            j++
        }

        // iterate over found relations, and add values
        for (property in propertyNameList) {
            if (property.startsWith("__") && property.endsWith("Key")) {

                // Adding __KEY in relation

                val neededObject = inputEntity[property.removePrefix("__").removeSuffix("Key")]
                if (neededObject is JSONObject) {
                    val neededKey = neededObject.getSafeString("__KEY")
                    associationMap[property]?.let { index ->
                        outputEntity[index] = neededKey
                    }
                }
            }
        }
        return outputEntity
    }
}