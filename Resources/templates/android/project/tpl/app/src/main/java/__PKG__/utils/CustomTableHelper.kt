/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import android.app.Application
import com.fasterxml.jackson.module.kotlin.readValue
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.relation.RelationHelper
import com.qmobile.qmobiledatasync.utils.GenericTableHelper
import com.qmobile.qmobiledatasync.utils.ReflectionUtils
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
{{#tableNames}}
import {{package}}.viewmodel.EntityListViewModel{{name}}
{{/tableNames}}
import kotlin.reflect.KParameter
import kotlin.reflect.KProperty1
import kotlin.reflect.full.declaredMemberProperties

/**
 * Provides different elements depending of the generated type
 */
class CustomTableHelper : GenericTableHelper {

    /**
     * Provides the list of table names
     */
    override fun tableNames(): List<String> = listOf({{#tableNames}}"{{name}}"{{^-last}}, {{/-last}}{{/tableNames}})

    /**
     * Provides the original table name. May contain spaces for example
     */
    override fun originalTableName(tableName: String): String = when (tableName) {
        {{#tableNames}}
        "{{name}}" -> "{{name_original}}"
        {{/tableNames}}
        else -> throw IllegalArgumentException("Missing original table name for table: $tableName")
    }

    /**
     * Provides the appropriate Entity
     */
     override fun parseEntityFromTable(
        tableName: String,
        jsonString: String,
        fetchedFromRelation: Boolean
    ): EntityModel? {
        var entity: EntityModel? = null
        {{#relations_many_to_one}}
        if (tableName == "{{relation_source}}") {
            if (entity == null)
                entity = BaseApp.mapper.readValue<{{relation_source}}>(jsonString)
            (entity as {{relation_source}}?)?.__{{relation_name}}Key =
                RelationHelper.getRelationId(jsonString, "{{relation_name_original}}", fetchedFromRelation)
        }
        {{/relations_many_to_one}}
        {{#tableNames_without_many_to_one_relation}}
        if (tableName == "{{name}}") {
            if (entity == null) {
                entity = BaseApp.mapper.readValue<{{name}}>(jsonString)
            }
        }
        {{/tableNames_without_many_to_one_relation}}
        return entity
    }

    /**
     * Provides the appropriate EntityListViewModel
     */
    override fun entityListViewModelFromTable(
        tableName: String,
        apiService: ApiService
    ): EntityListViewModel<*> =
        when (tableName) {
            {{#tableNames}}
            "{{name}}" -> EntityListViewModel{{name}}(tableName, apiService)
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing entityListViewModel for table: $tableName")
        }

    /**
     * Provides the appropriate EntityViewModel
     */
    override fun entityViewModelFromTable(
        tableName: String,
        id: String,
        apiService: ApiService
    ): EntityViewModel<*> =
        when (tableName) {
            {{#tableNames}}
            "{{name}}" -> EntityViewModel<{{name}}>(tableName, id, apiService)
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing entityViewModel for table: $tableName")
        }

    /**
     * Provides the appropriate EntityListViewModel KClass
     */
    @Suppress("UNCHECKED_CAST")
    override fun entityListViewModelClassFromTable(tableName: String): Class<EntityListViewModel<EntityModel>> =
        when (tableName) {
            {{#tableNames}}
            "{{name}}" -> EntityListViewModel{{name}}::class.java as Class<EntityListViewModel<EntityModel>>
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing entityListViewModel class for table: $tableName")
        }

    /**
     * Uses Kotlin reflection to retrieve type properties
     */
    @Suppress("UNCHECKED_CAST")
    override fun <T : EntityModel> getReflectedProperties(
        tableName: String
    ): Pair<Collection<KProperty1<T, *>>, List<KParameter>?> {
        val constructorParameters: List<KParameter>?
        val properties: Collection<*>
        when (tableName) {
            {{#tableNames}}
            "{{name}}" -> {
                properties = {{name}}::class.declaredMemberProperties as Collection<KProperty1<T, *>>
                constructorParameters = {{name}}::class.constructors.find { it.parameters.size > 1 }?.parameters
            }
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing reflected properties for table: $tableName")
        }
        return Pair(properties, constructorParameters)
    }

    /**
     * Returns list of table properties as a String, separated by commas, without EntityModel
     * inherited properties
     */
    override fun getPropertyListFromTable(tableName: String, application: Application): String {
        return when (tableName) {
            {{#tableNames}}
            "{{name}}" -> ReflectionUtils.getPropertyListString<{{name}}>(tableName, application)
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing property list for table: $tableName")
        }
    }
}
