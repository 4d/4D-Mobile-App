/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.utils

import android.app.Application
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.relation.Relation
import com.qmobile.qmobiledatasync.relation.RelationHelper
{{#tableNames}}
import {{prefix}}.{{company}}.{{app_name}}.data.model.entity.{{name}}
{{/tableNames}}
import kotlin.reflect.KProperty1
import kotlin.reflect.full.declaredMemberProperties

/**
 * Returns list of table properties as a String, separated by commas, without EntityModel
 * inherited properties
 */
@Suppress("UNCHECKED_CAST")
private fun <T : EntityModel> getPropertyListString(
    tableName: String,
    propertyMap: Map<String, String>,
    application: Application
): String {
    val entityModelProperties = EntityModel::class.declaredMemberProperties.map { it.name }
    val tableNames = BaseApp.fromTableForViewModel.tableNames()
    val properties: Collection<*>
    properties = when (tableName) {
        {{#tableNames}}
        "{{name}}" -> {{name}}::class.declaredMemberProperties as Collection<KProperty1<T, *>>
        {{/tableNames}}
        else -> throw IllegalArgumentException()
    }
    val names = mutableListOf<String>()
    for (property in properties.toList()) {
        var name: String = propertyMap[property.name] ?: property.name
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
        "{{name}}" -> getPropertyListString<{{name}}>(tableName, {{name}}.__propertyMap, application)
        {{/tableNames}}
        else -> throw IllegalArgumentException()
    }
}
