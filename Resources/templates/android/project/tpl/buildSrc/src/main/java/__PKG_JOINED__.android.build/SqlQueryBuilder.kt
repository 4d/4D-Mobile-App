/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.android.build

import {{package}}.android.build.model.Field
import {{package}}.android.build.utils.fieldAdjustment
import {{package}}.android.build.utils.getSafeString
import org.json.JSONArray
import org.json.JSONObject

class SqlQueryBuilder(entry: Any, private val fields: List<Field>) {
    /**
     * inputEntities can be a JSONArray, or a JSONObject.
     * It is a JSONArray when it receives a list of entities
     * It is a JSONObject when it's a related entity decoded from another table entities
     */

    val outputEntities = arrayListOf<Array<Any?>>()
    val hashMap = mutableMapOf<String, Any?>()
    val relatedEntitiesMap = mutableMapOf<String, MutableList<JSONObject>>()

    init {

        when (entry) {
            is JSONArray -> {
                for (i in 0 until entry.length()) {

                    hashMap["__KEY"] = null
                    hashMap["__TIMESTAMP"] = null
                    hashMap["__STAMP"] = null
                    fields.forEach { field ->
                        hashMap[field.name.fieldAdjustment()] = null
                        if (field.isManyToOneRelation)
                            hashMap["__${field.name.fieldAdjustment()}Key"] = null
                    }

                    val inputEntity = entry.getJSONObject(i)
                    val outputEntity = extractEntity(inputEntity)
                    outputEntities.add(outputEntity)
                }
            }
            is JSONObject -> {
                hashMap["__KEY"] = null
                hashMap["__TIMESTAMP"] = null
                hashMap["__STAMP"] = null
                fields.forEach { field ->
                    hashMap[field.name.fieldAdjustment()] = null
                    if (field.isManyToOneRelation)
                        hashMap["__${field.name.fieldAdjustment()}Key"] = null
                }

                val outputEntity = extractEntity(entry)
                outputEntities.add(outputEntity)
            }
        }
    }

    private fun extractEntity(inputEntity: JSONObject): Array<Any?> {

        val outputEntity = arrayOfNulls<Any>(hashMap.keys.size)

        inputEntity.keys().forEach { key ->
            if (hashMap.containsKey(key.fieldAdjustment())) {
                hashMap[key.fieldAdjustment()] = inputEntity[key]

                fields.find { it.name.fieldAdjustment() == key.fieldAdjustment() }?.let { field ->
                    when {
                        field.isImage -> {
                            // Nothing to do
                        }
                        field.isManyToOneRelation -> {
                            val neededObject = hashMap[key.fieldAdjustment()]
                            if (neededObject is JSONObject) {
                                hashMap["__${key.fieldAdjustment()}Key"] =
                                    neededObject.getSafeString("__KEY")
                                hashMap[key.fieldAdjustment()] = null

                                // add the relation in a new SqlQuery
                                field.relatedOriginalTableName?.let { originalTableName ->
                                    if (!relatedEntitiesMap.containsKey(originalTableName)) {
                                        relatedEntitiesMap[originalTableName] = mutableListOf()
                                    }
                                    relatedEntitiesMap[originalTableName]?.add(neededObject)
                                }
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
        for ((_, value) in sortedMap) {
            outputEntity[k] = value
            k++
        }
        return outputEntity
    }
}