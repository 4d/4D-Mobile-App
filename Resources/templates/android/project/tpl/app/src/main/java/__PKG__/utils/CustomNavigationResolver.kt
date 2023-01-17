/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import androidx.fragment.app.FragmentActivity
import androidx.navigation.findNavController
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomEntity
import com.qmobile.qmobiledatasync.utils.FeedbackType
import androidx.navigation.NavDirections
import com.qmobile.qmobiledatasync.utils.GenericNavigationResolver
import com.qmobile.qmobileui.BaseActionNavDirections
import com.qmobile.qmobileui.BaseNavDirections
import com.qmobile.qmobileui.action.actionparameters.ActionParametersFragmentDirections
import com.qmobile.qmobileui.activity.mainactivity.MainActivity
import com.qmobile.qmobileui.detail.viewpager.EntityViewPagerFragmentDirections
{{#isGoogleMapsPlatformUsedForTable}}
import com.qmobile.qmobileui.list.maps.MapsFragmentDirections
{{/isGoogleMapsPlatformUsedForTable}}
{{^isGoogleMapsPlatformUsedForTable}}
import com.qmobile.qmobileui.list.EntityListFragmentDirections
{{/isGoogleMapsPlatformUsedForTable}}
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
        sourceTable: String,
        position: Int,
        query: String,
        relationName: String,
        parentItemId: String,
        path: String,
        navbarTitle: String
    ) {
        viewDataBinding.root.findNavController().navigate(
            {{#isGoogleMapsPlatformUsedForTable}}
            MapsFragmentDirections.actionListToViewpager(
            {{/isGoogleMapsPlatformUsedForTable}}
            {{^isGoogleMapsPlatformUsedForTable}}
            EntityListFragmentDirections.actionListToViewpager(
            {{/isGoogleMapsPlatformUsedForTable}}
                sourceTable,
                position,
                query,
                relationName,
                parentItemId,
                path,
                navbarTitle
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
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.takeIf { it.isNotEmpty() }?.let {
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
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.takeIf { it.isNotEmpty() }?.let {
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
                    navbarTitle = "{{navbarTitle}}"
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
                    navbarTitle = "{{navbarTitle}}"
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
            BaseActionNavDirections.toActionForm(
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
     * Navigates to barcode scanner fragment
     */
    override fun navigateToActionScanner(fragmentActivity: FragmentActivity, fragmentResultKey: String) {
        (fragmentActivity as? MainActivity)?.navController?.navigate(
            BaseNavDirections.toScanner(fragmentResultKey = fragmentResultKey)

        )
    }

    /**
     * Navigates to TasksFragment
     */
    override fun navigateToPendingTasks(fragmentActivity: FragmentActivity, tableName: String, currentItemId: String) {
        (fragmentActivity as? MainActivity)?.navController?.navigate(
            BaseNavDirections.toPendingTasks(tableName = tableName, currentItemId = currentItemId)
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
        (fragmentActivity as? MainActivity)?.navController?.navigate(
            BaseActionNavDirections.toActionWebview(
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

    /**
     * Navigates to SettingsFragment
     */
    override fun navigateToSettings(fragmentActivity: FragmentActivity) {
        (fragmentActivity as? MainActivity)?.navController?.navigate(
            BaseNavDirections.toSettings()
        )
    }

    /**
     * Navigates to FeedbackFragment
     */
    override fun navigateToFeedback(fragmentActivity: FragmentActivity, type: FeedbackType) {
        (fragmentActivity as? MainActivity)?.navController?.navigate(
            SettingsFragmentDirections.toFeedback(type)
        )
    }



    /**
     * Navigates to details from deepLink
     */
    override fun navigateToDetailsFromDeepLink(fragmentActivity: FragmentActivity, tableName: String, itemId: String, navbarTitle: String) {
        val action = EntityListFragmentDirections.actionListToDetailRelation(
                tableName = tableName,
                itemId = itemId,
                navbarTitle = tableName
        )
        (fragmentActivity as? MainActivity)?.navController?.navigate(
                action
        )
    }


    /**
     * Navigates from detail form to (1>N) relation  when coming from deeplink
     */
    override fun navigateToDeepLinkOneToManyRelation(
            fragmentActivity: FragmentActivity,
            viewDataBinding: ViewDataBinding,
            relationName: String,
            roomEntity: RoomEntity
    ) {

        var  action : NavDirections? = null

        {{#relations_deeplink_one_to_many}}
        if (viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
        {{#isAlias}}
        (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.takeIf { it.isNotEmpty() }?.let {
        action = EntityListFragmentDirections.actionListToListRelation(
                relationName = relationName,
                parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                parentTableName = "{{relation_source}}",
                path = "{{path}}",
                navbarTitle = "{{navbarTitle}}"
        )
        {{/isAlias}}
        {{^isAlias}}
        (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
        action = EntityListFragmentDirections.actionListToListRelation(
                relationName = relationName,
                parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                parentTableName = "{{relation_source}}",
                path = "{{path}}",
                navbarTitle = "{{navbarTitle}}"
        )
        {{/isAlias}}
        }
    }
    {{/relations_deeplink_one_to_many}}
    {{#relations_deeplink_one_to_many}}
        if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
        {{#isAlias}}
        (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToManyWithoutFirst}}?.takeIf { it.isNotEmpty() }?.let {
        action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                relationName = relationName,
                parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                parentTableName = "{{relation_source}}",
                path = "{{path}}",
                navbarTitle = "{{navbarTitle}}"
        )
        {{/isAlias}}
        {{^isAlias}}
        (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.takeIf { it.isNotEmpty() }?.let {
        action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                relationName = relationName,
                parentItemId = (roomEntity.__entity as? EntityModel)?.__KEY ?: "",
                parentTableName = "{{relation_source}}",
                path = "{{path}}",
                navbarTitle = "{{navbarTitle}}"
        )
        {{/isAlias}}
    }
    }
    {{/relations_deeplink_one_to_many}}


    action?.let {
        (fragmentActivity as? MainActivity)?.navController?.navigate(
                it
        )
        }
    }

    /**
     * Navigates from detail form to (N>1) relation  when coming from deeplink
     */
    override fun navigateToDeepLinkManyToOneRelation(
            fragmentActivity: FragmentActivity,
            viewDataBinding: ViewDataBinding,
            relationName: String,
            roomEntity: RoomEntity
    ) {
        var  action : NavDirections? = null

        {{#relations_deeplink_many_to_one}}
        if (viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            action = EntityListFragmentDirections.actionListToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = "{{navbarTitle}}"
            )
        }
        }
        {{/relations_deeplink_many_to_one}}
        {{#relations_deeplink_many_to_one}}
            if (viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name}}") {
            {{#isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.{{pathToOneWithoutFirst}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            {{^isAlias}}
            (roomEntity as? {{relation_source}}RoomEntity)?.{{relation_name}}?.__KEY?.let { relationId ->
            {{/isAlias}}
            action = EntityViewPagerFragmentDirections.actionDetailToDetailRelation(
                    tableName = "{{relation_target}}",
                    itemId = relationId,
                    navbarTitle = "{{navbarTitle}}"
            )
        }
        }
        {{/relations_deeplink_many_to_one}}

            action?.let {
                (fragmentActivity as? MainActivity)?.navController?.navigate(
                        it
                )
            }
        }
}
