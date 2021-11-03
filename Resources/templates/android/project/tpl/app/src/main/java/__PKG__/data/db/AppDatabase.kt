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
import com.qmobile.qmobiledatastore.dao.RelationBaseDao
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatastore.db.DaoProvider
import {{package}}.data.converter.Converters
{{#tableNames}}
import {{package}}.data.dao.entity.{{name}}Dao
{{/tableNames}}
{{#relations_import}}
import {{package}}.data.dao.relation.{{relation_source}}Has{{relation_target}}With{{relation_name_cap}}KeyDao
{{/relations_import}}
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}

@Suppress("FunctionName")
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

    {{#relations_import}}
    abstract fun dao{{relation_source}}Has{{relation_target}}With{{relation_name_cap}}Key(): {{relation_source}}Has{{relation_target}}With{{relation_name_cap}}KeyDao
    {{/relations_import}}

    /**
     * Gets the appropriate DAO object
     */
    @Throws(IllegalArgumentException::class)
    @Suppress("UNCHECKED_CAST")
    override fun < T: Any> getDao(tableName: String): BaseDao<T> {
        return when (tableName) {
            {{#tableNames}}
            "{{name}}" -> dao{{name}}() as BaseDao<T>
            {{/tableNames}}
            else -> throw IllegalArgumentException("Missing dao for table: $tableName")
        }
    }

    @Throws(IllegalArgumentException::class)
    @Suppress("UNCHECKED_CAST")
    override fun getRelationDao(
        tableName: String,
        relatedTableName: String,
        relationName: String
    ): RelationBaseDao<RoomRelation> =
        when {
            {{#relations_import}}
            tableName == "{{relation_source}}" && relatedTableName == "{{relation_target}}" && relationName == "{{relation_name}}" ->
                dao{{relation_source}}Has{{relation_target}}With{{relation_name_cap}}Key() as RelationBaseDao<RoomRelation>
            {{/relations_import}}
            else -> throw IllegalArgumentException(
                "Missing relation dao for tableName: $tableName, " +
                    "relatedTableName: $relatedTableName, relationName: $relationName"
            )
        }        
}
