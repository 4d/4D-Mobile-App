/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils

import android.view.View
import androidx.navigation.findNavController
import com.qmobile.qmobiledatasync.utils.NavigationInterface
import com.qmobile.qmobileui.list.EntityListFragmentDirections

/**
 * Provides different elements depending of the generated type
 */
class NavigationImpl :
    NavigationInterface {

    /**
     * Navigates from ListView to ViewPager (which displays one DetailView)
     */
    override fun navigateFromListToViewPager(view: View, position: Int, tableName: String) {
        val action = EntityListFragmentDirections.actionListToViewpager(position, tableName)
        view.findNavController().navigate(action)
    }
}
