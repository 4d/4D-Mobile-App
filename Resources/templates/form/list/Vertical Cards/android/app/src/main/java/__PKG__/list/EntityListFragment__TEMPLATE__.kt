/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.list

import android.os.Bundle
import android.view.View
import androidx.databinding.ViewDataBinding
import androidx.recyclerview.widget.DividerItemDecoration
import com.qmobile.qmobiledatasync.utils.CustomEntityListFragment
import com.qmobile.qmobileui.databinding.FragmentListBinding

class EntityListFragment{{tableName}}(private val binding: ViewDataBinding) : CustomEntityListFragment {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        (binding as? FragmentListBinding)?.let {
            for (i in 0 until binding.fragmentListRecyclerView.itemDecorationCount) {
                if (binding.fragmentListRecyclerView.getItemDecorationAt(i) is DividerItemDecoration) {
                    binding.fragmentListRecyclerView.removeItemDecorationAt(i)
                }
            }
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        onViewCreated(binding.root, savedInstanceState)
    }
}
