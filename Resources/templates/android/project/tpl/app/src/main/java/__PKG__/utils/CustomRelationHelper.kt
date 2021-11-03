/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import android.app.Application
import androidx.lifecycle.LiveData
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatasync.relation.RelationHelper
import com.qmobile.qmobiledatasync.relation.RelationTypeEnum
import com.qmobile.qmobiledatasync.utils.GenericRelationHelper
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}

/**
 * Provides different elements depending of the generated type
 */
class CustomRelationHelper : GenericRelationHelper {

    /**
     * Retrieves the table name of a related field
     */
    override fun getRelatedTableName(sourceTableName: String, relationName: String): String =
        when {
            {{#relations_many_to_one}}
            sourceTableName == "{{relation_source}}" && relationName == "{{relation_name}}" -> "{{relation_target}}"
            {{/relations_many_to_one}}
            {{#relations_one_to_many}}
            sourceTableName == "{{relation_source}}" && relationName == "{{relation_name}}" -> "{{relation_target}}"
            {{/relations_one_to_many}}
            else -> throw IllegalArgumentException(
                "Missing related tableName for sourceTableName: $sourceTableName, " +
                    "relationName: $relationName"
            )
        }

    /**
     * Provides the relation map extracted from an entity
     */
    override fun getManyToOneRelationsInfo(
        tableName: String,
        entity: EntityModel
    ): Map<String, LiveData<RoomRelation>> {
        {{#has_any_many_to_one_relation}}
        val map = mutableMapOf<String, LiveData<RoomRelation>>()
        {{#relations_many_to_one}}
        // Many to One relations
        if (tableName == "{{relation_source}}") {
            (entity as? {{relation_source}})?.__{{relation_name}}Key?.let { relationId ->
                map["{{relation_name}}"] = RelationHelper.addRelation(
                    relationName = "{{relation_name}}", 
                    relationId = relationId, 
                    sourceTableName = tableName, 
                    relationType = RelationTypeEnum.MANY_TO_ONE
                )
            }
        }
        {{/relations_many_to_one}}
        return map
        {{/has_any_many_to_one_relation}}
        {{^has_any_many_to_one_relation}}
        return mutableMapOf()
        {{/has_any_many_to_one_relation}}
    }

    override fun getOneToManyRelationsInfo(
        tableName: String,
        entity: EntityModel
    ): Map<String, LiveData<RoomRelation>> {
        {{#has_any_one_to_many_relation}}
        val map = mutableMapOf<String, LiveData<RoomRelation>>()
        // One to Many relations
        {{#relations_one_to_many}}
        if (tableName == "{{relation_source}}") {
            (entity as? {{relation_source}})?.let {
                map["{{relation_name}}"] = RelationHelper.addRelation(
                    relationName = "{{relation_name}}", 
                    relationId = entity.__KEY, 
                    sourceTableName = tableName, 
                    inverseName = "{{inverse_name}}",
                    relationType = RelationTypeEnum.ONE_TO_MANY
                )
            }
        }
        {{/relations_one_to_many}}
        return map
        {{/has_any_one_to_many_relation}}
        {{^has_any_one_to_many_relation}}
        return mutableMapOf()
        {{/has_any_one_to_many_relation}}
    }

    /**
     * Returns list of table properties as a String, separated by commas, without EntityModel
     * inherited properties
     */
    override fun getPropertyListFromTable(tableName: String, application: Application): String {
        return when (tableName) {
            {{#tableNames}}
            "{{name}}" -> RelationHelper.getPropertyListString<{{name}}>(tableName, application)
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing property list for table: $tableName")
        }
    }

    /**
     * Provides the list of One to Many relations for given tableName
     */
    override fun getOneToManyRelationNames(tableName: String): List<String> = when (tableName) {
        {{#tableNames}}
        "{{name}}" -> listOf({{{concat_relations_one_to_many}}})
        {{/tableNames}}
        else -> throw IllegalArgumentException("Missing one to many relation names for table: $tableName")
    }

    /**
     * Provides the list of Many to One relations for given tableName
     */
    override fun getManyToOneRelationNames(tableName: String): List<String> = when (tableName) {
        {{#tableNames}}
        "{{name}}" -> listOf({{{concat_relations_many_to_one}}})
        {{/tableNames}}
        else -> throw IllegalArgumentException("Missing many to one relation names for table: $tableName")
    }
}
