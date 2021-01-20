/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.viewmodel.entity

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatastore.dao.RelationBaseDao
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames}}
import {{prefix}}.{{company}}.{{app_name}}.data.model.entity.{{name}}
{{/tableNames}}
{{#relations_import}}
import {{prefix}}.{{company}}.{{app_name}}.data.model.relation.{{relation_source}}And{{relation_target}}
{{/relations_import}}
import timber.log.Timber

class EntityViewModel{{tableName}}(
    tableName: String,
    id: String,
    apiService: ApiService
) :
    EntityViewModel<{{tableName}}>(tableName, id, apiService) {

    init {
        Timber.i("EntityViewModel{{tableName}} initializing...")
    }

    /**
     * DAO
     */

    {{#relations}}
    private val {{relation_name}}{{relation_source}}Has{{relation_target}}RelationDao: RelationBaseDao<RoomRelation> =
        BaseApp.appDatabaseInterface.getRelationDao(tableName, "{{relation_target}}")
    {{/relations}}

    /**
     * LiveData
     */

    {{#relations}}
    val {{relation_name}} = MutableLiveData<{{relation_target}}>()
    {{/relations}}

    override fun getManyToOneRelationKeysFromEntity(entity: EntityModel): Map<String, LiveData<RoomRelation>> {
        val map = mutableMapOf<String, LiveData<RoomRelation>>()
        if (entity is {{tableName}}) {
            {{#relations}}
            entity.__{{relation_name}}Key?.let {
                Timber.e("__{{relation_name}}Key retrieved is = $it")
                map.put(
                    "{{relation_name}}",
                    {{relation_name}}{{relation_source}}Has{{relation_target}}RelationDao.getManyToOneRelation(relationId = it)
                )
            }
            {{/relations}}
        }
        return map
    }
    override fun setRelationToLayout(relationName: String, roomRelation: RoomRelation) {
        when (relationName) {
            {{#relations}}
            "{{relation_name}}" -> {
                {{relation_name}}.postValue((roomRelation as {{relation_source}}And{{relation_target}}).first)
            }
            {{/relations}}
            else -> return
        }
    }
}
