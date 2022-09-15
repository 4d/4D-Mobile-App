/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils


import android.view.View
import com.qmobile.qmobiledatasync.utils.BaseInputControl
import com.qmobile.qmobiledatasync.utils.GenericActionHelper
{{#input_controls}}
import {{package}}.inputcontrol.{{class_name}}
{{/input_controls}}

/**
 * Provides different elements depending of the generated type
 */
class CustomActionHelper : GenericActionHelper {

    /**
     * Gets the appropriate input control class
     */
    override fun getInputControl(itemView: View, format: String?): BaseInputControl? = when (format) {
        {{#input_controls}}
        "/{{name}}" -> {{class_name}}(itemView)
        {{/input_controls}}
        else -> null
    }
}
