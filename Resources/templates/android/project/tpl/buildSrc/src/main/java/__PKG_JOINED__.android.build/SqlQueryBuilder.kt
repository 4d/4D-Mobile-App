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
    val hashMap = mutableMapOf<String, Any?>()

    init {
        hashMap["__KEY"] = null
        hashMap["__TIMESTAMP"] = null
        hashMap["__STAMP"] = null
        fields.forEach { field ->
            hashMap[field.name.condenseSpaces()] = null
            if (field.isManyToOneRelation)
                hashMap["__${field.name.condenseSpaces()}Key"] = null
        }

        for (i in 0 until inputEntities.length()) {

            val inputEntity = inputEntities.getJSONObject(i)
            val outputEntity = extractEntity(inputEntity)
            outputEntities.add(outputEntity)
        }
    }

    private fun extractEntity(inputEntity: JSONObject): Array<Any?> {

        val outputEntity = arrayOfNulls<Any>(hashMap.keys.size)

        inputEntity.keys().forEach { key ->
            if (hashMap.containsKey(key.condenseSpaces())) {
                hashMap[key.condenseSpaces()] = inputEntity[key]

                fields.find { it.name == key }?.let { field ->
                    when {
                        field.isImage -> {
                            hashMap[key.condenseSpaces()] = null
                        }
                        field.isManyToOneRelation -> {
                            val neededObject = hashMap[key.condenseSpaces()]
                            if (neededObject is JSONObject) {
                                hashMap["__${key.condenseSpaces()}Key"] = neededObject.getSafeString("__KEY")
                            }
                        }
                        field.isOneToManyRelation -> {
                            // TODO
                        }
                    }
                }
            }
        }

        val sortedMap = hashMap.toSortedMap()
        var k = 0
        for ((key, value) in sortedMap) {
            println("[key = $key] value = $value")
            outputEntity[k] = value
            k++
        }

        return outputEntity
    }
}