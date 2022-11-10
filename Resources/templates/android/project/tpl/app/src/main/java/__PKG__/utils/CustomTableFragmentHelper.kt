/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import com.qmobile.qmobiledatasync.utils.CustomEntityListFragment
import com.qmobile.qmobiledatasync.utils.GenericTableFragmentHelper
import com.qmobile.qmobiledatasync.utils.LayoutType
import com.qmobile.qmobileui.detail.EntityDetailFragment
{{#has_custom_formatter_images}}
import {{package}}.R
{{/has_custom_formatter_images}}
{{#tableNames_navigation}}
import {{package}}.detail.EntityFragment{{name}}
{{/tableNames_navigation}}
{{#tableNames_navigation}}
import {{package}}.list.EntityListFragment{{name}}
{{/tableNames_navigation}}

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
     * Provides the list form type
     */
    override fun layoutType(tableName: String): LayoutType = when (tableName) {
        {{#tableNames_layout}}
        "{{name}}" -> {{layout_manager_type}}
        {{/tableNames_layout}}
        else -> LayoutType.LINEAR
    }

    /**
     * Provides if horizontal swipe on items is allowed
     */
    override fun isSwipeAllowed(tableName: String): Boolean = when (tableName) {
        {{#tableNames_layout}}
        "{{name}}" -> {{isSwipeAllowed}}
        {{/tableNames_layout}}
        else -> false
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
    ): CustomEntityListFragment? = when (tableName) {
        {{#tableNames_navigation}}
        "{{name}}" -> EntityListFragment{{name}}(binding)
        {{/tableNames_navigation}}
        else -> null
    }

    /**
     * Provides drawable resources for navigation tabs
     */
    override fun getNavIcon(tableName: String): Int? = when (tableName) {
        {{#tableNames_navigation_for_navbar}}
        {{#hasIcon}}
        "{{label}}" -> {{icon}}
        {{/hasIcon}}
        {{^hasIcon}}
        "{{label}}" -> null
        {{/hasIcon}}
        {{/tableNames_navigation_for_navbar}}
        else -> null
    }
}
