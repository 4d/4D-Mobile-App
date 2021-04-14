/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.utils.FragmentUtil
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
import com.qmobile.qmobileui.BR
{{#tableNames_navigation}}
import {{package}}.databinding.FragmentDetail{{nameCamelCase}}Binding
{{/tableNames_navigation}}
import {{package}}.databinding.FragmentListBinding
{{#tableNames_navigation}}
import {{package}}.databinding.RecyclerviewItem{{nameCamelCase}}Binding
{{/tableNames_navigation}}
{{#tableNames}}
import {{package}}.viewmodel.entity.EntityViewModel{{name}}
{{/tableNames}}

/**
 * Provides different elements depending of the generated type
 */
class FragmentUtilImpl :
    FragmentUtil {

    /**
     * Sets the appropriate EntityListViewModel
     */
    @Suppress("UNCHECKED_CAST")
    override fun setEntityListViewModel(
        viewDataBinding: ViewDataBinding,
        entityListViewModel: EntityListViewModel<EntityModel>
    ) {
        viewDataBinding as FragmentListBinding
        viewDataBinding.viewModel = entityListViewModel
    }

    /**
     * Sets the appropriate EntityViewModel
     */
    @Suppress("UNCHECKED_CAST")
    override fun setEntityViewModel(
        viewDataBinding: ViewDataBinding,
        entityViewModel: EntityViewModel<EntityModel>
    ) {
        when (viewDataBinding) {
            {{#tableNames_navigation}}
            is FragmentDetail{{nameCamelCase}}Binding -> viewDataBinding.viewModel = entityViewModel as EntityViewModel{{name}}
            {{/tableNames_navigation}}
            else -> throw java.lang.IllegalArgumentException()
        }
    }

    /**
     * Provides the list form type
     */
    override fun layoutType(tableName: String): String = when (tableName) {
        {{#tableNames_layout}}
        "{{name}}" -> "{{layout_manager_type}}"
        {{/tableNames_layout}}
        else -> "LINEAR"
    }

    /**
     * Sets relations to the appropriate list form
     */
    override fun setRelationBinding(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        relatedEntity: Any
    ) {
        {{#tableNames_layout_relations}}
        if (viewDataBinding is RecyclerviewItem{{relation_source}}Binding) {
            if (relationName == "{{relation_name}}") {
                viewDataBinding.setVariable(BR.{{relation_name}}, relatedEntity)
            }
        }
        {{/tableNames_layout_relations}}
    }

    /**
     * Reset relations as PagedListAdapter generates issue with relations
     */
    override fun unsetRelationBinding(viewDataBinding: ViewDataBinding) {
        {{#tableNames_layout_relations}}
        if (viewDataBinding is RecyclerviewItem{{relation_source}}Binding) {
            viewDataBinding.setVariable(BR.{{relation_name}}, null)
        }
        {{/tableNames_layout_relations}}
    }
}
