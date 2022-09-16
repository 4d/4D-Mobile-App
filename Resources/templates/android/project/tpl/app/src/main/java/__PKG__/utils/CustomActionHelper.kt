/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils


import android.view.View
import com.qmobile.qmobiledatasync.utils.BaseKotlinInputControl
import com.qmobile.qmobiledatasync.utils.GenericActionHelper
{{#kotlin_input_controls}}
import {{package}}.inputcontrol.{{class_name}}
{{/kotlin_input_controls}}

/**
 * Provides different elements depending of the generated type
 */
class CustomActionHelper : GenericActionHelper {

    /**
     * Gets the appropriate input control class
     */
    override fun getKotlinInputControl(itemView: View, format: String?): BaseKotlinInputControl? = when (format) {
        {{#kotlin_input_controls}}
        "/{{name}}" -> {{class_name}}(itemView)
        {{/kotlin_input_controls}}
        else -> null
    }
}
