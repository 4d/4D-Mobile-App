/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.list

import android.os.Bundle
import android.view.View
import androidx.databinding.ViewDataBinding
import com.qmobile.qmobiledatasync.utils.CustomEntityListFragment

class EntityListFragment{{tableName}}(private val binding: ViewDataBinding) : CustomEntityListFragment {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        // Nothing to do
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        onViewCreated(binding.root, savedInstanceState)
    }
}
