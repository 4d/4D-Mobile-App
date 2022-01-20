/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import androidx.databinding.ViewDataBinding
import androidx.navigation.findNavController
import com.qmobile.qmobileapi.model.entity.EntityModel
import com.qmobile.qmobiledatastore.data.RoomData
import com.qmobile.qmobiledatasync.utils.GenericNavigationResolver
import com.qmobile.qmobileui.detail.viewpager.EntityViewPagerFragmentDirections
import com.qmobile.qmobileui.list.EntityListFragmentDirections
{{#tableNames}}
import {{package}}.data.model.entity.{{name}}
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
        currentItemId: String,
        inverseName: String
    ) {
        val action = when (viewDataBinding) {
            {{#tableNames_navigation}}
            is RecyclerviewItem{{nameCamelCase}}Binding -> EntityListFragmentDirections.actionListToViewpager(
                key,
                "{{name}}",
                query,
                destinationTable,
                currentItemId,
                inverseName                
            )
            {{/tableNames_navigation}}
            else -> null
        }
        action?.let { viewDataBinding.root.findNavController().navigate(action) }
    }

    /**
     * Navigates from list form to another list form (One to Many relation)
     */
    override fun setupOneToManyRelationButtonOnClickActionForCell(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        parentItemId: String,
        entity: EntityModel,
        anyRelatedEntity: RoomData?
    ) {
        {{#has_any_relations_one_to_many_for_list}}
        when {
            {{#relations_one_to_many_for_list}}
            viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name_original}}" -> {
                {{#isSubRelation}}
                (entity as? {{relation_source}})?.__{{inverse_name}}Key?.let { destParentId ->
                    val action = EntityListFragmentDirections.actionListToListRelation(
                        destinationTable = "{{relation_target}}",
                        currentItemId = destParentId,
                        inverseName = "{{inverse_name}}",
                        navbarTitle = "{{navbarTitle}}"
                    )
                    viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                        viewDataBinding.root.findNavController().navigate(action)
                    }
                }
                {{/isSubRelation}}
                {{^isSubRelation}}
                val action = EntityListFragmentDirections.actionListToListRelation(
                    destinationTable = "{{relation_target}}",
                    currentItemId = parentItemId,
                    inverseName = "{{inverse_name}}",
                    navbarTitle = "{{navbarTitle}}"
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
                {{/isSubRelation}}
            }
            {{/relations_one_to_many_for_list}}
        }
        {{/has_any_relations_one_to_many_for_list}}
    }

    /**
     * Navigates from list form to a detail form (Many to One relation)
     */
    override fun setupManyToOneRelationButtonOnClickActionForCell(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        entity: EntityModel
    ) {
        {{#has_any_relations_many_to_one_for_list}}
        when {
            {{#relations_many_to_one_for_list}}
            viewDataBinding is RecyclerviewItem{{relation_source_camelCase}}Binding && relationName == "{{relation_name_original}}" -> {
                (entity as? {{relation_source}})?.__{{relation_name}}Key?.let { relationId ->
                    val action = EntityListFragmentDirections.actionListToDetailRelation(
                        tableName = "{{relation_target}}",
                        itemId = relationId,
                        navbarTitle = ""
                    )
                    viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                        viewDataBinding.root.findNavController().navigate(action)
                    }
                }
            }
            {{/relations_many_to_one_for_list}}
        }
        {{/has_any_relations_many_to_one_for_list}}
    }

    /**
     * Navigates from detail form to a list form (One to Many relation)
     */
    override fun setupOneToManyRelationButtonOnClickActionForDetail(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        parentItemId: String,
        entity: EntityModel,
        anyRelatedEntity: RoomData?
    ) {
        {{#has_any_relations_one_to_many_for_detail}}
        when {
            {{#relations_one_to_many_for_detail}}
            viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name_original}}" -> {
                {{#isSubRelation}}
                (entity as? {{relation_source}})?.__{{inverse_name}}Key?.let { destParentId ->
                    val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                        destinationTable = "{{relation_target}}",
                        currentItemId = destParentId,
                        inverseName = "{{inverse_name}}",
                        navbarTitle = "{{navbarTitle}}"
                    )
                    viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                        viewDataBinding.root.findNavController().navigate(action)
                    }
                }
                {{/isSubRelation}}
                {{^isSubRelation}}
                val action = EntityViewPagerFragmentDirections.actionDetailToListRelation(
                    destinationTable = "{{relation_target}}",
                    currentItemId = parentItemId,
                    inverseName = "{{inverse_name}}",
                    navbarTitle = "{{navbarTitle}}"
                )
                viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                    viewDataBinding.root.findNavController().navigate(action)
                }
                {{/isSubRelation}}
            }
            {{/relations_one_to_many_for_detail}}
        }
        {{/has_any_relations_one_to_many_for_detail}}
    }

    /**
     * Navigates from detail form to another detail form (Many to One relation)
     */
    override fun setupManyToOneRelationButtonOnClickActionForDetail(
        viewDataBinding: ViewDataBinding,
        relationName: String,
        entity: EntityModel
    ) {
        {{#has_any_relations_many_to_one_for_detail}}
        when {
            {{#relations_many_to_one_for_detail}}
            viewDataBinding is FragmentDetail{{relation_source_camelCase}}Binding && relationName == "{{relation_name_original}}" -> {
                (entity as? {{relation_source}})?.__{{relation_name}}Key?.let { relationId ->
                    val action = EntityViewPagerFragmentDirections.actionDetailToDetailRelation(
                        tableName = "{{relation_target}}",
                        itemId = relationId,
                        navbarTitle = ""
                    )
                    viewDataBinding.{{tableNameLowercase}}FieldValue{{associatedViewId}}.setOnClickListener {
                        viewDataBinding.root.findNavController().navigate(action)
                    }
                }
            }
            {{/relations_many_to_one_for_detail}}
        }
        {{/has_any_relations_many_to_one_for_detail}}
    }

    /**
     * Navigates from list form to action form
     */
    override fun navigateToActionForm(
        viewDataBinding: ViewDataBinding,
        destinationTable: String,
        navBarTitle: String,
        inverseName: String,
        parentItemId: String,
        fromRelation: Boolean
    ) {
       viewDataBinding.root.findNavController().navigate(
            EntityListFragmentDirections.actionListToActionForm(
                destinationTable,
                inverseName,
                parentItemId,
                fromRelation,
                navBarTitle
            )
        ) 
    }
}
