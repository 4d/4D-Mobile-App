/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.model.relation

import androidx.room.Embedded
import androidx.room.Relation
import com.qmobile.qmobiledatastore.data.RoomRelation
import {{package}}.data.model.entity.{{relation_source}}
{{^relation_same_type}}
import {{package}}.data.model.entity.{{relation_target}}
{{/relation_same_type}}

class {{relation_source}}And{{relation_target}}With{{relation_name_cap}}Key(
    @Embedded override val toOne: {{relation_target}}?,
    @Relation(
        parentColumn = "__KEY",
        entityColumn = "__{{relation_name}}Key"
    )
    override val toMany: List<{{relation_source}}>
) : RoomRelation
