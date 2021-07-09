/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.navigation.findNavController
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatasync.utils.GenericTableFragmentHelper
import com.qmobile.qmobiledatasync.viewmodel.EntityViewModel
import com.qmobile.qmobileui.BR
import com.qmobile.qmobileui.detail.EntityDetailFragment
import {{package}}.R
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
import {{package}}.list.EntityListFragment{{name}}Directions
{{/tableNames_navigation}}
{{#tableNames}}
import {{package}}.viewmodel.entity.EntityViewModel{{name}}
{{/tableNames}}
import java.lang.IllegalArgumentException

/**
 * Provides different elements depending of the generated type
 */
class CustomTableFragmentHelper :
    GenericTableFragmentHelper {

    /**
     * Navigates from ListView to ViewPager (which displays one DetailView)
     */
    override fun navigateFromListToViewPager(view: View, position: Int, tableName: String) {
        val action = when (tableName) {
            {{#tableNames_navigation}}
            "{{name}}" -> EntityListFragment{{name}}Directions.actionListToViewpager(position, tableName)
            {{/tableNames_navigation}}
            else -> null
        }
        action?.let { view.findNavController().navigate(action) }
    }

    /**
     * Gets the appropriate detail fragment
     */
    override fun getDetailFragment(itemId: String, tableName: String): EntityDetailFragment =
        when (tableName) {
            {{#tableNames_navigation}}
            "{{name}}" -> EntityFragment{{name}}()
            {{/tableNames_navigation}}
            else -> throw IllegalArgumentException()
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
            else -> throw IllegalArgumentException()
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
                Pair(R.drawable.{{resourceName}}, R.drawable.{{resourceNameDarkMode}})
                {{/darkModeExists}}
                {{^darkModeExists}}
                Pair(R.drawable.{{resourceName}}, 0)
                {{/darkModeExists}}
            {{/custom_formatter_images}}
            else -> null
        }
    }
}
