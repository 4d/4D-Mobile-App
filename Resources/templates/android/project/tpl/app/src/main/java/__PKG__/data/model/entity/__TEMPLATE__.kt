/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.model.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonProperty
{{#table_has_one_to_many_field}}
import com.qmobile.qmobileapi.model.entity.Entities
{{/table_has_one_to_many_field}}
import com.qmobile.qmobileapi.model.entity.EntityModel
{{#table_has_any_many_to_one_relation}}
import com.qmobile.qmobileapi.model.entity.ManyToOneRelationMask
{{/table_has_any_many_to_one_relation}}
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobiledatastore.data.RoomData
{{#table_has_time_field}}
import java.sql.Time
{{/table_has_time_field}}
{{#table_has_date_field}}
import java.util.Date
{{/table_has_date_field}}

@Suppress("ConstructorParameterNaming", "LongParameterList", "ObjectPropertyNaming", "ClassName")
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
{{#table_has_any_many_to_one_relation}}

@Suppress("ConstructorParameterNaming", "LongParameterList")
class {{tableName}}ManyToOneRelationMask(
    {{#relations_many_to_one}}
    @JsonProperty("{{relation_name_original}}") val {{relation_name}}: ManyToOneRelationMask? = null{{^-last}}, {{/-last}}
    {{/relations_many_to_one}}
)
{{/table_has_any_many_to_one_relation}}
