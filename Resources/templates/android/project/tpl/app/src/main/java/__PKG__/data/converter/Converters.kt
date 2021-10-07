/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.converter

import androidx.room.TypeConverter
import com.google.gson.Gson
import com.qmobile.qmobileapi.model.entity.Entities
import com.qmobile.qmobileapi.model.entity.Photo
import com.qmobile.qmobiledatastore.utils.ConverterUtils
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
import java.sql.Time
import java.util.Date

/**
 * Type converters to allow Room to reference complex data types.
 */
@Suppress("TooManyFunctions", "FunctionName")
class Converters {

    private val gson = Gson()

    /**
     * Converts custom table Object to Json String
     */

    {{#tableNames}}
    @TypeConverter
    fun customTableObjectToStringEntities{{name}}(obj: Entities<{{name}}>?): String =
        ConverterUtils.customTableObjectToString(gson, obj)

    {{/tableNames}}

    {{#types_and_tables}}
    @TypeConverter
    fun customTableObjectToString{{name}}(obj: {{name}}?): String =
        ConverterUtils.customTableObjectToString(gson, obj)

    {{/types_and_tables}}

    /**
     * Converts custom table Json String to Photo Object
     */

    {{#tableNames}}
    @TypeConverter
    fun customTableStringToObjectEntities{{name}}(str: String?): Entities<{{name}}>? =
        ConverterUtils.customTableStringToObject(gson, str)

    {{/tableNames}}

    {{#types_and_tables}}
    @TypeConverter
    fun customTableStringToObject{{name}}(str: String?): {{name}}? =
        ConverterUtils.customTableStringToObject(gson, str)

    {{/types_and_tables}}
}
