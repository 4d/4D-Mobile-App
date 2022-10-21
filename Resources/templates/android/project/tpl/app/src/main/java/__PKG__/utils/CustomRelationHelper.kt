/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomEntity
import com.qmobile.qmobiledatasync.relation.Relation
import com.qmobile.qmobiledatasync.utils.GenericRelationHelper
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
import {{package}}.data.model.entity.{{name}}RoomEntity
{{/tableNames}}

/**
 * Provides different elements depending of the generated type
 */
class CustomRelationHelper : GenericRelationHelper {

    /**
     * Returns the list of relations
     */
    override fun getRelations(): List<Relation> = listOf(
        {{#relations}}
        Relation("{{relation_source}}", "{{relation_target}}", "{{relation_name}}", "{{inverse_name}}", {{relationType}}, "{{path}}"){{^-last}}, {{/-last}}
        {{/relations}}
    )

    /**
     * Get relation Id for a given entity
     */
    override fun getRelationId(tableName: String, relationName: String, entity: EntityModel): String? = when {
        {{#relations_id}}
        tableName == "{{relation_source}}" && relationName == "{{relation_name}}" -> (entity as? {{relation_source}})?.__{{relation_name}}Key
        {{/relations_id}}
        else -> null
    }

    /**
     * Checks equality in 2 RoomEntities relations
     */
    override fun relationsEquals(oldItem: RoomEntity, newItem: RoomEntity): Boolean {   
        {{#relations_many_to_one}}
        {{#isAlias}}
        if (oldItem is {{relation_source}}RoomEntity && oldItem.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__STAMP != (newItem as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__STAMP) {
        {{/isAlias}}
        {{^isAlias}}
        if (oldItem is {{relation_source}}RoomEntity && oldItem.{{relation_name}}?.__STAMP != (newItem as? {{relation_source}}RoomEntity)?.{{relation_name}}?.__STAMP) {
        {{/isAlias}}
            return false
        }
        {{/relations_many_to_one}}
        {{#relations_one_to_many}}
        {{#isAlias}}
        if (oldItem is {{relation_source}}RoomEntity && oldItem.{{relation_name}}?.{{pathToManyWithoutFirst}}?.size != (newItem as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.size) {
        {{/isAlias}}
        {{^isAlias}}
        if (oldItem is {{relation_source}}RoomEntity && oldItem.{{relation_name}}?.size != (newItem as? {{relation_source}}RoomEntity)?.{{relation_name}}?.size) {
        {{/isAlias}}
            return false
        }
        {{/relations_one_to_many}}
        return true
    }
}
