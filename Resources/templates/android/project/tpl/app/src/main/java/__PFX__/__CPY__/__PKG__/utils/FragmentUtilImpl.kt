/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.utils

import androidx.databinding.ViewDataBinding
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.utils.FragmentUtil
import com.qmobile.qmobiledatasync.viewmodel.EntityListViewModel
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#tableNames_navigation}}
import {{prefix}}.{{company}}.{{app_name}}.databinding.FragmentDetail{{nameCamelCase}}Binding
{{/tableNames_navigation}}
import {{prefix}}.{{company}}.{{app_name}}.databinding.FragmentListBinding
{{#tableNames}}
import {{prefix}}.{{company}}.{{app_name}}.viewmodel.entity.EntityViewModel{{name}}
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
        {{#tableNames_navigation}}
        "{{name}}" -> "{{layout_manager_type}}"
        {{/tableNames_navigation}}
        else -> "LINEAR"
    }
}
