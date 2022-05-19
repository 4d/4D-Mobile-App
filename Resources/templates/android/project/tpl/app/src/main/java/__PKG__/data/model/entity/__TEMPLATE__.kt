/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.model.entity

import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Relation
import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonProperty
{{#table_has_one_to_many_field}}
import com.qmobile.qmobileapi.model.entity.Entities
{{/table_has_one_to_many_field}}
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobiledatastore.data.RoomData
import com.qmobile.qmobiledatastore.data.RoomEntity
{{#table_has_time_field}}
import java.sql.Time
{{/table_has_time_field}}
{{#table_has_date_field}}
import java.util.Date
{{/table_has_date_field}}
{{#entity_relations}}
import {{package}}.data.model.{{entity_relation_name}}
{{/entity_relations}}
{{#relations_embedded_return_type}}
import {{package}}.data.model.{{className}}
{{/relations_embedded_return_type}}

@Entity
class {{tableName}}(
    {{#fields}}
    @JsonProperty("{{name_original}}") {{variableType}} {{name}}: {{{fieldTypeString}}}? = null,
    {{/fields}}
    @PrimaryKey
    override val __KEY: String,
    override val __STAMP: Int? = null,
    override val __GlobalStamp: Int? = null,
    override val __TIMESTAMP: String? = null
) : EntityModel, RoomData {
    
    @JsonCreator
    private constructor() : this(__KEY = "")
}

data class {{tableName}}RoomEntity(
    @Embedded
    override val __entity: {{tableName}},
{{#relations_one_to_many}}
    @Relation(
        entity = {{firstTarget}}::class,
        {{#firstIsToMany}}
        parentColumn = "__KEY",
        entityColumn = "__{{key_name}}Key"
        {{/firstIsToMany}}
        {{^firstIsToMany}}
        parentColumn = "__{{key_name}}Key",
        entityColumn = "__KEY"
        {{/firstIsToMany}}
    )
    {{#firstIsToMany}}
    val {{relation_name}}: List<{{relation_embedded_return_type}}>? = null,
    {{/firstIsToMany}}
    {{^firstIsToMany}}
    val {{relation_name}}: {{relation_embedded_return_type}}? = null,
    {{/firstIsToMany}}
{{/relations_one_to_many}}
{{#relations_many_to_one}}
    @Relation(
        entity = {{firstTarget}}::class,
        parentColumn = "__{{key_name}}Key",
        entityColumn = "__KEY"
    )
    val {{relation_name}}: {{relation_embedded_return_type}}? = null,
{{/relations_many_to_one}}
) : RoomEntity
