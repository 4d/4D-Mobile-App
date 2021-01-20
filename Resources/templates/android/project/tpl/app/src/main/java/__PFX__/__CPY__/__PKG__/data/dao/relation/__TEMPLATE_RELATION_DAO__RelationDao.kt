/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.data.dao.relation

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Query
import androidx.room.Transaction
import com.qmobile.qmobiledatastore.dao.RelationBaseDao
import {{prefix}}.{{company}}.{{app_name}}.data.model.relation.{{relation_source}}And{{relation_target}}

@Dao
abstract class {{relation_source}}Has{{relation_target}}RelationDao : RelationBaseDao<{{relation_source}}And{{relation_target}}> {

    @Transaction
    @Query("SELECT * FROM {{relation_target}} WHERE __KEY = :relationId")
    abstract override fun getManyToOneRelation(relationId: String): LiveData<{{relation_source}}And{{relation_target}}>
}
