/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.utils


import android.view.View
import androidx.fragment.app.FragmentActivity
import com.qmobile.qmobiledatasync.utils.BaseKotlinInputControl
import com.qmobile.qmobiledatasync.utils.GenericResourceHelper
import com.qmobile.qmobiledatasync.utils.LoginHandler
import com.qmobile.qmobileui.activity.loginactivity.LoginActivity
{{#kotlin_input_controls}}
import {{package}}.inputcontrol.{{class_name}}
{{/kotlin_input_controls}}
{{#has_custom_login}}
import {{package}}.login.{{login_class_name}}
{{/has_custom_login}}
{{^has_custom_login}}
import com.qmobile.qmobileui.activity.loginactivity.DefaultLogin
{{/has_custom_login}}

/**
 * Provides different elements depending of the generated type
 */
class CustomResourceHelper : GenericResourceHelper {

    /**
     * Gets the appropriate input control class
     */
    {{#has_kotlin_input_controls}}
    override fun getKotlinInputControl(itemView: View, format: String?): BaseKotlinInputControl? = when (format) {
        {{#kotlin_input_controls}}
        "/{{name}}" -> {{class_name}}(itemView)
        {{/kotlin_input_controls}}
        else -> null
    }
    {{/has_kotlin_input_controls}}
    {{^has_kotlin_input_controls}}
    override fun getKotlinInputControl(itemView: View, format: String?): BaseKotlinInputControl? = null
    {{/has_kotlin_input_controls}}

    /**
     * Gets the login form
     */
    override fun getLoginForm(activity: FragmentActivity): LoginHandler {
        return {{login_class_name}}(activity as LoginActivity)
    }
}
