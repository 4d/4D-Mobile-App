/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.list

import android.os.Bundle
import androidx.recyclerview.widget.DividerItemDecoration
import com.qmobile.qmobileui.list.EntityListFragment

class EntityListFragment{{tableName}} : EntityListFragment() {

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        for (i in 0 until binding.fragmentListRecyclerView.itemDecorationCount) {
            if (binding.fragmentListRecyclerView.getItemDecorationAt(i) is DividerItemDecoration)
                binding.fragmentListRecyclerView.removeItemDecorationAt(i)
        }
    }
}
