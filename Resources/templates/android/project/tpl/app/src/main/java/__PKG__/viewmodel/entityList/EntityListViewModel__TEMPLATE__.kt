/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.viewmodel.entityList

import androidx.lifecycle.LiveData
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatastore.dao.RelationBaseDao
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import {{package}}.data.model.entity.{{tableName}}
import timber.log.Timber

class EntityListViewModel{{tableName}}(

    tableName: String,
    apiService: ApiService
) :
    EntityListViewModel<{{tableName}}>(tableName, apiService) {

    init {
        Timber.v("EntityListViewModel{{tableName}} initializing...")
    }

    /**
     * DAO
     */

    {{#relations}}
    private val {{relation_name}}{{relation_source}}Has{{relation_target}}RelationDao: RelationBaseDao<RoomRelation> =
        BaseApp.appDatabaseInterface.getRelationDao(tableName, "{{relation_target}}")
    {{/relations}}

    override fun getManyToOneRelationKeysFromEntityList(
        entityList: List<EntityModel>
    ): MutableMap<String, MutableMap<String, LiveData<RoomRelation>>> {

        // Map<entityKey, Map<relationName, LiveData<RoomRelation>>>
        val map = mutableMapOf<String, MutableMap<String, LiveData<RoomRelation>>>()
        entityList.forEach { entity ->
            entity.__KEY?.let { key ->
                map[key] = mutableMapOf()
                if (entity is {{tableName}}) {
                    {{#relations}}
                    entity.__{{relation_name}}Key?.let {
                        Timber.d("[$originalAssociatedTableName] __{{relation_name}}Key retrieved is = $it")
                        map[key]?.apply {
                            put(
                                "{{relation_name}}",
                                {{relation_name}}{{relation_source}}Has{{relation_target}}RelationDao.getManyToOneRelation(relationId = it)
                            )
                        }
                    }
                    {{/relations}}
                }
            }
        }
        return map
    }
}
