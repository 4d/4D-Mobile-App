/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.data.model.entity

import androidx.room.Entity
import androidx.room.PrimaryKey
import com.google.gson.annotations.SerializedName
import com.qmobile.qmobileapi.model.entity.Entities
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.model.entity.ManyToOneRelationMask
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobiledatastore.data.RoomData
import java.sql.Time
import java.util.Date

@Suppress("ConstructorParameterNaming", "LongParameterList", "ObjectPropertyNaming")
@Entity
class {{tableName}}(
    {{#fields}}
    @SerializedName("{{name_original}}") {{variableType}} {{name}}: {{{fieldTypeString}}}? = null,
    {{/fields}}
    @PrimaryKey
    override val __KEY: String,
    override val __STAMP: Int? = null,
    override val __GlobalStamp: Int? = null,
    override val __TIMESTAMP: String? = null
) : EntityModel, RoomData {
    companion object {
        @Suppress("ObjectPropertyName")
        val __propertyMap = mapOf(
            {{#fields}}
            "{{name}}" to "{{name_original}}"{{^-last}}, {{/-last}}
            {{/fields}}
        )
    }
}

@Suppress("ConstructorParameterNaming", "LongParameterList")
class {{tableName}}ManyToOneRelationMask(
    {{#relations}}
    val {{relation_name}}: ManyToOneRelationMask? = null{{^-last}}, {{/-last}}
    {{/relations}}
)
