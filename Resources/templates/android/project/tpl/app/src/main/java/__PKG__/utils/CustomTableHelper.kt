/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import com.fasterxml.jackson.module.kotlin.readValue
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.relation.RelationHelper
import com.qmobile.qmobiledatasync.section.SectionField
import com.qmobile.qmobiledatasync.utils.GenericTableHelper
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
{{#tableNames}}
import {{package}}.viewmodel.EntityListViewModel{{name}}
{{/tableNames}}

/**
 * Provides different elements depending of the generated type
 */
class CustomTableHelper : GenericTableHelper {

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
            (entity as? {{relation_source}})?.__{{relation_name}}Key =
                RelationHelper.getRelationId(jsonString, "{{relation_name_original}}", fetchedFromRelation)
        }
        {{/relations_many_to_one}}
        {{#tableNames_without_many_to_one_relation}}
        if (tableName == "{{name}}") {
            if (entity == null)
                entity = BaseApp.mapper.readValue<{{name}}>(jsonString)
        }
        {{/tableNames_without_many_to_one_relation}}
        // Empty relations
        {{#relations_without_alias}}
        if (tableName == "{{relation_source}}")
            (entity as? {{relation_source}})?.{{relation_name}} = null
        {{/relations_without_alias}}
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
     * Provides the appropriate section field
     */
    override fun getSectionFieldForTable(tableName: String): QueryField? {
        return when (tableName) {
            {{#section_fields}}
            "{{tableName}}" -> QueryField("{{name}}", "{{valueType}}", "{{path}}")
            {{/section_fields}}
            else -> null
        }
    }

    /**
     * Provides the appropriate default sort field
     */
    override fun getDefaultSortFieldForTable(tableName: String): QueryField? {
        return when (tableName) {
            {{#default_sort_fields}}
            "{{tableName}}" -> QueryField("{{name}}", "{{valueType}}")
            {{/default_sort_fields}}
            else -> null
        }
    }
}
