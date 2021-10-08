/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.viewmodel.entity

{{#table_has_any_relation}}
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
{{/table_has_any_relation}}
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

@Suppress("ClassName")
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
    private val _{{relation_name}} = MutableLiveData<{{relation_target}}?>()
    val {{relation_name}}: LiveData<{{relation_target}}?> = _{{relation_name}}
    {{/relations}}

    override fun setRelationToLayout(relationName: String, roomRelation: RoomRelation) {
    {{#table_has_any_relation}}
        when (relationName) {
            {{#relations}}
            "{{relation_name}}" -> {
                _{{relation_name}}.postValue((roomRelation as {{relation_source}}And{{relation_target}}).first)
            }
            {{/relations}}
            else -> return
        }
    {{/table_has_any_relation}}
    {{^table_has_any_relation}}
        // No relation
    {{/table_has_any_relation}}
    }
}
