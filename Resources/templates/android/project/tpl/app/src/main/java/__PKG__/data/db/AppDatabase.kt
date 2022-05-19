/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.db

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.qmobile.qmobiledatastore.dao.BaseDao
import com.qmobile.qmobiledatastore.data.RoomData
import com.qmobile.qmobiledatastore.data.RoomEntity
import com.qmobile.qmobiledatastore.db.DaoProvider
import {{package}}.data.converter.Converters
{{#tableNames}}
import {{package}}.data.dao.entity.{{name}}Dao
{{/tableNames}}
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}

@Database(
    entities = [{{entity_classes}}],
    version = 1,
    exportSchema = true
)
@TypeConverters(Converters::class)
abstract class AppDatabase :
    RoomDatabase(),
    DaoProvider {

    {{#tableNames}}
    abstract fun dao{{name}}(): {{name}}Dao
    {{/tableNames}}

    /**
     * Gets the appropriate DAO object
     */
    @Suppress("UNCHECKED_CAST")
    override fun getDao(source: String): BaseDao<RoomEntity, RoomData> {
        return when (source) {
            {{#tableNames}}
            "{{name}}" -> dao{{name}}() as BaseDao<RoomEntity, RoomData>
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing dao for table: $source")
        }
    }    
}
