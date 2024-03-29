/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.detail

import android.os.Bundle
import android.view.View
import com.qmobile.qmobileui.detail.EntityDetailFragment
import {{package}}.databinding.FragmentDetail{{tableName_nameCamelCase}}Binding

class EntityFragment{{tableName}} : EntityDetailFragment() {

    private val dataBinding get() = super.binding as FragmentDetail{{tableName_nameCamelCase}}Binding

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }
}
