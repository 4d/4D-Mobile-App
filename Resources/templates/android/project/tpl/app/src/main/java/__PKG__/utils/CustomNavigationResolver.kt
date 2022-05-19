/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import androidx.navigation.findNavController
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomEntity
import com.qmobile.qmobiledatasync.utils.GenericNavigationResolver
import com.qmobile.qmobileui.action.ActionParametersFragmentDirections
import com.qmobile.qmobileui.detail.viewpager.EntityViewPagerFragmentDirections
import com.qmobile.qmobileui.list.EntityListFragmentDirections
import com.qmobile.qmobileui.ui.disableLink
import com.qmobile.qmobileui.ui.enableLink
import com.qmobile.qmobileui.ui.setOnSingleClickListener
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
import {{package}}.data.model.entity.{{name}}RoomEntity
{{/tableNames}}
{{#tableNames_navigation}}
import {{package}}.databinding.FragmentDetail{{nameCamelCase}}Binding
{{/tableNames_navigation}}
{{#tableNames_navigation}}
import {{package}}.databinding.RecyclerviewItem{{nameCamelCase}}Binding
{{/tableNames_navigation}}

/**
 * Interface providing different elements depending of the generated type
 */
class CustomNavigationResolver : GenericNavigationResolver {

    /**
     * Navigates from list form to ViewPager (which displays one detail form)
     */
    override fun navigateFromListToViewPager(
        viewDataBinding: ViewDataBinding,
        key: String,
        query: String,
        destinationTable: String,
        parentItemId: String,
        parentTableName: String,
        path: String
    ) {
        val action = when (viewDataBinding) {
            {{#tableNames_navigation}}
            is RecyclerviewItem{{nameCamelCase}}Binding -> EntityListFragmentDirections.actionListToViewpager(
                key,
                "{{name}}",
                query,
                destinationTable,
                parentItemId,
                parentTableName,
                path               
            )
            {{/tableNames_navigation}}
            else -> null
        }
        action?.let { viewDataBinding.root.findNavController().navigate(action) }
    }

    /**
     * Navigates from list or detail form to a relation list form (One to Many relation)
     */
    override fun setupOneToManyRelationButtonOnClickAction(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        roomEntity: RoomEntity
    ) {
        {{#relations_one_to_many_for_list}}
        if (viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.let {
                val action = EntityListFragmentDirections.actionListToListRelation(
                    destinationTable = "{{relation_target}}",
                    parentItemId = (roomEntity.__entity as EntityModel?)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity?)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
                val action = EntityListFragmentDirections.actionListToListRelation(
                    destinationTable = "{{relation_target}}",
                    parentItemId = (roomEntity.__entity as EntityModel?)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.enableLink()
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnSingleClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_one_to_many_for_list}}
        {{#relations_one_to_many_for_detail}}
        if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.let {
                val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                    destinationTable = "{{relation_target}}",
                    parentItemId = (roomEntity.__entity as EntityModel?)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity?)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
                val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                    destinationTable = "{{relation_target}}",
                    parentItemId = (roomEntity.__entity as EntityModel?)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.enableLink()
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnSingleClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_one_to_many_for_detail}}
    }

    /**
     * Navigates from list or detail form to a relation detail form (Many to One relation)
     */
    override fun setupManyToOneRelationButtonOnClickAction(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        roomEntity: RoomEntity
    ) {
        {{#relations_many_to_one_for_list}}
        if (viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
                val action = EntityListFragmentDirections.actionListToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = ""
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.enableLink()
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnSingleClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_many_to_one_for_list}}
        {{#relations_many_to_one_for_detail}}
        if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as {{relation_source}}RoomEntity?)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
                val action = EntityViewPagerFragmentDirections.actionDetailToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = ""
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.enableLink()
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnSingleClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_many_to_one_for_detail}}
    }

    /**
     * Navigates from list or detail form to action form
     */
    override fun navigateToActionForm(
        viewDataBinding: ViewDataBinding,
        tableName: String,
        itemId: String,
        relationName: String,
        parentItemId: String,
        navbarTitle: String
    ) {
        viewDataBinding.root.findNavController().navigate(
            EntityListFragmentDirections.actionListToActionForm(
                tableName = tableName,
                itemId = itemId,
                relationName = relationName,
                parentItemId = parentItemId,
                navbarTitle = navbarTitle
            )
        )
    }

    /**
     * Navigates from action form to barcode scanner fragment
     */
    override fun navigateToActionScanner(viewDataBinding: ViewDataBinding, position: Int) {
        viewDataBinding.root.findNavController().navigate(
            ActionParametersFragmentDirections.actionParametersToScanner(position)
        )
    }
}
