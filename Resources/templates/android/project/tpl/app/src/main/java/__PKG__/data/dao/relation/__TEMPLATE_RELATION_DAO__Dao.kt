/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.dao.relation

import androidx.lifecycle.LiveData
import androidx.room.Dao
import androidx.room.Query
import androidx.room.Transaction
import com.qmobile.qmobiledatastore.dao.RelationBaseDao
import {{package}}.data.model.relation.{{relation_source}}And{{relation_target}}With{{relation_name_cap}}Key

@Dao
abstract class {{relation_source}}Has{{relation_target}}With{{relation_name_cap}}KeyDao : RelationBaseDao<{{relation_source}}And{{relation_target}}With{{relation_name_cap}}Key> {

    @Transaction
    @Query("SELECT * FROM {{relation_target}} WHERE __KEY = :relationId")
    abstract override fun getRelation(relationId: String): LiveData<{{relation_source}}And{{relation_target}}With{{relation_name_cap}}Key>
}
