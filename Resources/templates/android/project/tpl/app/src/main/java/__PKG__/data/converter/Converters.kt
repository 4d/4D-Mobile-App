/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.converter

import androidx.room.TypeConverter
import com.qmobile.qmobileapi.model.entity.Entities
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobileapi.utils.parseToString
import com.qmobile.qmobileapi.utils.parseToType
import com.qmobile.qmobiledatasync.app.BaseApp
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
import java.sql.Time
import java.util.Date

/**
 * Type converters to allow Room to reference complex data types.
 */
class Converters {

    /**
     * Converts custom table Object to Json String
     */

    {{#tableNames}}
    @TypeConverter
    fun customTableObjectToStringEntities{{name}}(obj: Entities<{{type}}>?): String =
        BaseApp.mapper.parseToString(obj)

    {{/tableNames}}
    {{#types_and_tables}}
    @TypeConverter
    fun customTableObjectToString{{name}}(obj: {{type}}?): String =
        BaseApp.mapper.parseToString(obj)

    {{/types_and_tables}}

    /**
     * Converts custom table Json String to table Object
     */

    {{#tableNames}}
    @TypeConverter
    fun customTableStringToObjectEntities{{name}}(str: String?): Entities<{{type}}>? =
        BaseApp.mapper.parseToType(str)

    {{/tableNames}}
    {{#types_and_tables}}
    @TypeConverter
    fun customTableStringToObject{{name}}(str: String?): {{type}}? =
        BaseApp.mapper.parseToType(str)

    {{/types_and_tables}}
}
