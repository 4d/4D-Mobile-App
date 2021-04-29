/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import android.app.Application
import com.fasterxml.jackson.annotation.JsonProperty
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.relation.Relation
import com.qmobile.qmobiledatasync.relation.RelationHelper
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
import kotlin.reflect.KParameter
import kotlin.reflect.KProperty1
import kotlin.reflect.full.declaredMemberProperties
import kotlin.reflect.full.findAnnotation

/**
 * Returns list of table properties as a String, separated by commas, without EntityModel
 * inherited properties
 */
@Suppress("UNCHECKED_CAST")
private fun <T : EntityModel> getPropertyListString(
    tableName: String,
    application: Application
): String {
    val entityModelProperties = EntityModel::class.declaredMemberProperties.map { it.name }
    val tableNames = BaseApp.fromTableForViewModel.tableNames()
    val properties: Collection<*>
    val constructorParameters: List<KParameter>?
    when (tableName) {
        {{#tableNames}}
        "{{name}}" -> {
            properties = {{name}}::class.declaredMemberProperties as Collection<KProperty1<T, *>>
            constructorParameters = 
                {{name}}::class.constructors.find { it.parameters.size > 1 }?.parameters
        }
        {{/tableNames}}
        else -> throw IllegalArgumentException()
    }
    val names = mutableListOf<String>()
    for (property in properties.toList()) {
        val propertyName: String = property.name

        val serializedName: String? = constructorParameters?.find { it.name == propertyName }
            ?.findAnnotation<JsonProperty>()?.value

        var name: String = serializedName ?: propertyName

        if (RelationHelper.isManyToOneRelation(property, application, tableNames) != null ||
            RelationHelper.isOneToManyRelation(property, application, tableNames) != null
        ) {
            name += Relation.SUFFIX
        }
        names.add(name)
    }

    val difference = names.toSet().minus(entityModelProperties.toSet())
    return difference.toString().filter { it !in "[]" }
}

fun getPropertyListFromTable(tableName: String, application: Application): String {
    return when (tableName) {
        {{#tableNames}}
        "{{name}}" -> getPropertyListString<{{name}}>(tableName, application)
        {{/tableNames}}
        else -> throw IllegalArgumentException()
    }
}
