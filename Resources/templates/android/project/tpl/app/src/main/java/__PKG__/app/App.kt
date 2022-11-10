/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.app

import com.google.android.material.color.DynamicColors
import com.google.android.material.color.DynamicColorsOptions
import com.qmobile.qmobileapi.utils.SharedPreferencesHolder
import com.qmobile.qmobiledatastore.db.AppDatabaseFactory
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.utils.RuntimeDataHolder
import {{package}}.BuildConfig
import {{package}}.R
import {{package}}.data.db.AppDatabase
import {{package}}.utils.CustomActionHelper
import {{package}}.utils.CustomNavigationResolver
import {{package}}.utils.CustomRelationHelper
import {{package}}.utils.CustomTableFragmentHelper
import {{package}}.utils.CustomTableHelper

class App : BaseApp() {

    override fun onCreate() {
        super.onCreate()

        // Apply dynamic color
        val dynamicColorOptions = DynamicColorsOptions.Builder().setThemeOverlay(R.style.Theme_MyApplication).build()
        DynamicColors.applyToActivitiesIfAvailable(this, dynamicColorOptions)

        // Sets interfaces to get data coming from outside the SDK
        daoProvider =
            AppDatabaseFactory.getAppDatabase(applicationContext, AppDatabase::class.java)
        genericTableHelper = CustomTableHelper()
        genericRelationHelper = CustomRelationHelper()
        genericTableFragmentHelper = CustomTableFragmentHelper()
        genericNavigationResolver = CustomNavigationResolver()
        genericActionHelper = CustomActionHelper()

        // Init SharedPreferences, persisting data
        sharedPreferencesHolder = SharedPreferencesHolder.getInstance(this).apply {
            init()
        }

        // Init runtime data holder
        runtimeDataHolder = RuntimeDataHolder.init(this, BuildConfig.DEBUG)

        // Sets the drawable resource id for login page logo
        loginLogoDrawable = R.drawable.logo

        // Sets navigation graphs id list for navigation
        navGraphIds = listOf(
            {{#tableNames_navigation_for_navbar}}
            R.navigation.{{nameLowerCase}}{{^-last}}, {{/-last}}
            {{/tableNames_navigation_for_navbar}}
        )
    }
}
