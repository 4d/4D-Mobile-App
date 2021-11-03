/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.utils.CustomEntityListFragment
import com.qmobile.qmobiledatasync.utils.GenericTableFragmentHelper
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
{{#has_relation}}
import com.qmobile.qmobileui.BR
{{/has_relation}}
import com.qmobile.qmobileui.detail.EntityDetailFragment
{{#has_custom_formatter_images}}
import {{package}}.R
{{/has_custom_formatter_images}}
{{#tableNames_navigation}}
import {{package}}.databinding.FragmentDetail{{nameCamelCase}}Binding
{{/tableNames_navigation}}
{{#tableNames_navigation}}
import {{package}}.databinding.RecyclerviewItem{{nameCamelCase}}Binding
{{/tableNames_navigation}}
{{#tableNames_navigation}}
import {{package}}.detail.EntityFragment{{name}}
{{/tableNames_navigation}}
{{#tableNames_navigation}}
import {{package}}.list.EntityListFragment{{name}}
{{/tableNames_navigation}}
{{#tableNames}}
import {{package}}.viewmodel.entity.EntityViewModel{{name}}
{{/tableNames}}

/**
 * Provides different elements depending of the generated type
 */
class CustomTableFragmentHelper :
    GenericTableFragmentHelper {

    /**
     * Gets the appropriate detail fragment
     */
    override fun getDetailFragment(tableName: String): EntityDetailFragment =
        when (tableName) {
            {{#tableNames_navigation}}
            "{{name}}" -> EntityFragment{{name}}()
            {{/tableNames_navigation}}
            else -> throw IllegalArgumentException("Missing detail fragment for table: $tableName")
        }

    /**
     * Sets the appropriate EntityViewModel
     */
    override fun setEntityViewModel(
        viewDataBinding: ViewDataBinding,
        entityViewModel: EntityViewModel<EntityModel>
    ) {
        when (viewDataBinding) {
            {{#tableNames_navigation}}
            is FragmentDetail{{nameCamelCase}}Binding -> viewDataBinding.viewModel = entityViewModel as EntityViewModel{{name}}
            {{/tableNames_navigation}}
            else -> throw IllegalArgumentException("Missing viewDataBinding: $viewDataBinding")
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

     /**
     * Provides drawable resources for custom formatters
     */
    override fun getDrawableForFormatter(formatName: String, imageName: String): Pair<Int, Int>? {
        return when {
            {{#custom_formatter_images}}
            formatName == "{{formatterName}}" && imageName == "{{imageName}}" ->
                {{#darkModeExists}}
                Pair(
                    R.drawable.{{resourceName}},
                    R.drawable.{{resourceNameDarkMode}}
                )
                {{/darkModeExists}}
                {{^darkModeExists}}
                Pair(R.drawable.{{resourceName}}, 0)
                {{/darkModeExists}}
            {{/custom_formatter_images}}
            else -> null
        }
    }

    /**
     * Provides the custom list fragment as list forms are given as a base fragment_list
     */
    override fun getCustomEntityListFragment(
        tableName: String,
        binding: ViewDataBinding
    ): CustomEntityListFragment = when (tableName) {
        {{#tableNames_navigation}}
        "{{name}}" -> EntityListFragment{{name}}(binding)
        {{/tableNames_navigation}}
        else -> throw IllegalArgumentException("Missing custom entity list fragment for table  $tableName")
    }
}
