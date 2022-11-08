/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import androidx.fragment.app.FragmentActivity
import androidx.navigation.Navigation
import androidx.navigation.findNavController
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomEntity
import com.qmobile.qmobiledatasync.utils.GenericNavigationResolver
import com.qmobile.qmobileui.R
import com.qmobile.qmobileui.action.actionparameters.ActionParametersFragmentDirections
import com.qmobile.qmobileui.detail.viewpager.EntityViewPagerFragmentDirections
import com.qmobile.qmobileui.list.EntityListFragmentDirections
import com.qmobile.qmobileui.settings.SettingsFragmentDirections
import com.qmobile.qmobileui.ui.disableLink
import com.qmobile.qmobileui.ui.setOnNavigationClickListener
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
        position: Int,
        query: String,
        sourceTable: String,
        relationName: String,
        parentItemId: String,
        path: String
    ) {
        viewDataBinding.root.findNavController().navigate(
            EntityListFragmentDirections.actionListToViewpager(
                key,
                position,
                sourceTable,
                query,
                relationName,
                parentItemId,
                path
            )
        )
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
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.let {
                val action = EntityListFragmentDirections.actionListToListRelation(
                    relationName = relationName,
                    parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
                val action = EntityListFragmentDirections.actionListToListRelation(
                    relationName = relationName,
                    parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnNavigationClickListener(viewDataBinding, action)
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_one_to_many_for_list}}
        {{#relations_one_to_many_for_detail}}
        if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.let {
                val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                    relationName = relationName,
                    parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
                val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                    relationName = relationName,
                    parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                    parentTableName = "{{relation_source}}",
                    path = "{{path}}",
                    navbarTitle = "{{navbarTitle}}"
                )
            {{/isAlias}}
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnNavigationClickListener(viewDataBinding, action)
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
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
                val action = EntityListFragmentDirections.actionListToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = ""
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnNavigationClickListener(viewDataBinding, action)
            } ?: kotlin.run {
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.disableLink()
            }
        }
        {{/relations_many_to_one_for_list}}
        {{#relations_many_to_one_for_detail}}
        if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
                val action = EntityViewPagerFragmentDirections.actionDetailToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = ""
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnNavigationClickListener(viewDataBinding, action)
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
        pendingTaskId: String,
        actionUUID: String,
        navbarTitle: String
    ) {
        viewDataBinding.root.findNavController().navigate(
            SettingsFragmentDirections.toActionForm(
                tableName = tableName,
                itemId = itemId,
                relationName = relationName,
                parentItemId = parentItemId,
                taskId = pendingTaskId,
                actionUUID = actionUUID,
                navbarTitle = navbarTitle
            )
        )
    }

    /**
     * Navigates from action form to barcode scanner fragment
     */
    override fun navigateToActionScanner(viewDataBinding: ViewDataBinding, position: Int) {
        viewDataBinding.root.findNavController().navigate(
            ActionParametersFragmentDirections.actionParametersToScanner(position = position)
        )
    }

    /**
     * Navigates to TasksFragment
     */
    override fun navigateToPendingTasks(fragmentActivity: FragmentActivity, tableName: String, currentItemId: String) {
        Navigation.findNavController(fragmentActivity, R.id.nav_host_container).navigate(
            SettingsFragmentDirections.toPendingTasks(tableName = tableName, currentItemId = currentItemId)
        )
    }

    /**
     * Navigates to ActionWebViewFragment
     */
    override fun navigateToActionWebView(
        fragmentActivity: FragmentActivity, 
        path: String, 
        actionName: String, 
        actionLabel: String?, 
        actionShortLabel: String?, 
        base64EncodedContext: String
    ) {
        Navigation.findNavController(fragmentActivity, R.id.nav_host_container).navigate(
            EntityListFragmentDirections.toActionWebView(
                path = path,
                actionName = actionName,
                actionLabel = actionLabel ?: "",
                actionShortLabel = actionShortLabel ?: "",
                base64EncodedContext = base64EncodedContext
            )
        )
    }
    
    /**
     * Navigates to PushInputControlFragment
     */
    override fun navigateToPushInputControl(
        viewDataBinding: ViewDataBinding,
        inputControlName: String,
        mandatory: Boolean
    ) {
        viewDataBinding.root.findNavController().navigate(
            ActionParametersFragmentDirections.actionParametersToPushInputControl(
                name = inputControlName,
                mandatory = mandatory
            )
        )
    }
}
