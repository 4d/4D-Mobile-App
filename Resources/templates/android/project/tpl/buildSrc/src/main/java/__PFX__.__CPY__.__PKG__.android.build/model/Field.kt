/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.android.build.model

data class Field(
    var name: String,
    var isImage: Boolean = false,
    var isOneToManyRelation: Boolean = false,
    var isManyToOneRelation: Boolean = false
)