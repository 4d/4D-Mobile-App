/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.data.dao.entity

import androidx.lifecycle.LiveData
import androidx.paging.DataSource
import androidx.paging.PagingSource
import androidx.room.Dao
import androidx.room.Query
import androidx.room.RawQuery
import androidx.sqlite.db.SupportSQLiteQuery
import com.qmobile.qmobiledatastore.dao.BaseDao
import {{package}}.data.model.entity.{{tableName}}

@Suppress("ClassName")
@Dao
abstract class {{tableName}}Dao :
    BaseDao<{{tableName}}>() {

    override val tableName: String = "{{tableName}}"

    @Query("SELECT * FROM {{tableName}}")
    abstract override fun getAll(): LiveData<List<{{tableName}}>>

    @Query("SELECT * FROM {{tableName}} WHERE __KEY = :id")
    abstract override fun getOne(id: String): LiveData<{{tableName}}>

    @Query("DELETE FROM {{tableName}} WHERE __KEY = :id")
    abstract override suspend fun deleteOne(id: String)

    @Query("DELETE FROM {{tableName}}")
    abstract override suspend fun deleteAll()

    @RawQuery(observedEntities = [{{tableName}}::class])
    abstract override fun getAllPagedList(sqLiteQuery: SupportSQLiteQuery): DataSource.Factory<Int, {{tableName}}>

    @RawQuery(observedEntities = [{{tableName}}::class])
    abstract override fun getAllPagingData(sqLiteQuery: SupportSQLiteQuery): PagingSource<Int, {{tableName}}>
}
