/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.lifecycle.LiveData
import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.readValue
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatasync.relation.RelationHelper
import com.qmobile.qmobiledatasync.relation.RelationTypeEnum
import com.qmobile.qmobiledatasync.utils.GenericTableHelper
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
import {{package}}.data.model.entity.{{name}}ManyToOneRelationMask
{{/tableNames}}
{{#tableNames}}
import {{package}}.viewmodel.entity.EntityViewModel{{name}}
{{/tableNames}}
{{#tableNames}}
import {{package}}.viewmodel.entityList.EntityListViewModel{{name}}
{{/tableNames}}
import kotlin.reflect.KParameter
import kotlin.reflect.KProperty1
import kotlin.reflect.full.declaredMemberProperties

/**
 * Provides different elements depending of the generated type
 */
class CustomTableHelper : GenericTableHelper {

    private var mapper: ObjectMapper = ObjectMapper()
        .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
        .registerKotlinModule()

    /**
     * Provides the list of table names
     */
    override fun tableNames(): List<String> = mutableListOf<String>().apply {
        {{#tableNames}}
        add("{{name}}")
        {{/tableNames}}
    }

    override fun originalTableName(tableName: String): String = when (tableName) {
        {{#tableNames}}
        "{{name}}" -> "{{name_original}}"
        {{/tableNames}}
        else -> throw IllegalArgumentException()
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
        {{#tableNames_relations}}
        if (tableName == "{{relation_source}}") {
            if (entity == null) {
                entity = mapper.readValue<{{relation_source}}>(jsonString)
            }
            if (fetchedFromRelation) {
                val entityManyToOneRelationMask =
                    mapper.readValue<{{relation_source}}ManyToOneRelationMask>(jsonString)
                (entity as {{relation_source}}?)?.__{{relation_name}}Key = entityManyToOneRelationMask.{{relation_name}}?.__deferred?.__KEY
            } else {
                (entity as {{relation_source}}?)?.__{{relation_name}}Key = entity.{{relation_name}}?.__KEY
            }
            entity.{{relation_name}} = null
        }
        {{/tableNames_relations}}
        {{#tableNames_without_relations}}
        if (tableName == "{{name}}") {
            if (entity == null) {
                entity = mapper.readValue<{{name}}>(jsonString)
            }
        }
        {{/tableNames_without_relations}}
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
            else -> throw IllegalArgumentException()
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
            "{{name}}" -> EntityViewModel{{name}}(tableName, id, apiService)
            {{/tableNames}}
            else -> throw IllegalArgumentException()
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
            else -> throw IllegalArgumentException()
        }

    /**
     * Provides the appropriate EntityViewModel KClass
     */
    @Suppress("UNCHECKED_CAST")
    override fun entityViewModelClassFromTable(tableName: String): Class<EntityViewModel<EntityModel>> =
        when (tableName) {
            {{#tableNames}}
            "{{name}}" -> EntityViewModel{{name}}::class.java as Class<EntityViewModel<EntityModel>>
            {{/tableNames}}
            else -> throw IllegalArgumentException()
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
            else -> throw IllegalArgumentException()
        }
        return Pair(properties, constructorParameters)
    }
    
    /**
     * Retrieves the table name of a related field
     */
    override fun getRelatedTableName(sourceTableName: String, relationName: String): String {
        {{#tableNames_relations}}
        if (sourceTableName == "{{relation_source}}" && relationName == "{{relation_name}}")
            return "{{relation_target}}"
        {{/tableNames_relations}}
        throw IllegalArgumentException()
    }

    /**
     * Provides the relation map extracted from an entity
     */
    override fun getRelationsInfo(
        tableName: String,
        entity: EntityModel
    ): Map<String, LiveData<RoomRelation>> {
        val map = mutableMapOf<String, LiveData<RoomRelation>>()
        {{#tableNames_relations}}
        if (tableName == "{{relation_source}}") {
            (entity as? {{relation_source}})?.__{{relation_name}}Key?.let {
                map["{{relation_name}}"] = RelationHelper.getManyToOneRelation(
                    relationId = it,
                    sourceTableName = tableName,
                    relationName = "{{relation_name}}"
                )
            }
        }
        {{/tableNames_relations}}
        return map
    }
}
