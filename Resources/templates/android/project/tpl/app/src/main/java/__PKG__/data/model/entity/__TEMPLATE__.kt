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
import com.qmobile.qmobileapi.model.entity.Entities
import com.qmobile.qmobileapi.model.entity.EntityModel
{{#has_any_relation}}
import com.qmobile.qmobileapi.model.entity.ManyToOneRelationMask
{{/has_any_relation}}
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobiledatastore.data.RoomData
import java.sql.Time
import java.util.Date

@Suppress("ConstructorParameterNaming", "LongParameterList", "ObjectPropertyNaming")
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
{{#has_any_relation}}

@Suppress("ConstructorParameterNaming", "LongParameterList")
class {{tableName}}ManyToOneRelationMask(
    {{#relations}}
    val {{relation_name}}: ManyToOneRelationMask? = null{{^-last}}, {{/-last}}
    {{/relations}}
)
{{/has_any_relation}}
