/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.model

import androidx.room.Embedded
import androidx.room.Relation
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}

{{#relations_embedded_return_type}}
data class {{className}}(
    @Embedded val {{relation_source_camelCase}}: {{relation_source}},
    @Relation(
        {{#firstIsToMany}}
        parentColumn = "__KEY",
        entityColumn = "__{{key_name}}Key",
        {{/firstIsToMany}}
        {{^firstIsToMany}}
        parentColumn = "__{{key_name}}Key",
        entityColumn = "__KEY",
        {{/firstIsToMany}}
        entity = {{firstTarget}}::class
    )
    {{#firstIsToMany}}
    val {{relation_part_name}}: List<{{relation_embedded_return_type}}>? = null
    {{/firstIsToMany}}
    {{^firstIsToMany}}
    val {{relation_part_name}}: {{relation_embedded_return_type}}? = null
    {{/firstIsToMany}}
)

{{/relations_embedded_return_type}}