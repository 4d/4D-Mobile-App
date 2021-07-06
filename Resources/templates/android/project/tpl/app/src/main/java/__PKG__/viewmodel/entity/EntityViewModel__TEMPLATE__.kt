/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.viewmodel.entity

import androidx.lifecycle.MutableLiveData
import com.qmobile.qmobileapi.network.ApiService
import com.qmobile.qmobiledatastore.data.RoomRelation
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
{{/tableNames}}
{{#relations_import}}
import {{package}}.data.model.relation.{{relation_source}}And{{relation_target}}
{{/relations_import}}
import timber.log.Timber

class EntityViewModel{{tableName}}(
    tableName: String,
    id: String,
    apiService: ApiService
) :
    EntityViewModel<{{tableName}}>(tableName, id, apiService) {

    init {
        Timber.v("EntityViewModel{{tableName}} initializing...")
    }

    /**
     * LiveData
     */

    {{#relations}}
    val {{relation_name}} = MutableLiveData<{{relation_target}}?>()
    {{/relations}}

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
