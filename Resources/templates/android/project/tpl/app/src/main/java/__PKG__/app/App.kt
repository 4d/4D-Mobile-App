/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.app

import com.fasterxml.jackson.databind.DeserializationFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.module.kotlin.registerKotlinModule
import com.qmobile.qmobileapi.utils.SharedPreferencesHolder
import com.qmobile.qmobiledatastore.db.AppDatabaseFactory
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.utils.RuntimeDataHolder
import {{package}}.BuildConfig
import {{package}}.R
import {{package}}.data.db.AppDatabase
import {{package}}.utils.CustomTableFragmentHelper
import {{package}}.utils.CustomTableHelper

class App : BaseApp() {

    override fun onCreate() {
        super.onCreate()

        // Sets interfaces to get data coming from outside the SDK
        daoProvider =
            AppDatabaseFactory.getAppDatabase(applicationContext, AppDatabase::class.java)
        genericTableHelper = CustomTableHelper()
        genericTableFragmentHelper = CustomTableFragmentHelper()
        mapper = ObjectMapper()
            .configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false)
            .registerKotlinModule()
            .enable(SerializationFeature.INDENT_OUTPUT)
        //    .registerModule(KotlinModule(nullIsSameAsDefault = true))

        // Init SharedPreferences, persisting data
        sharedPreferencesHolder = SharedPreferencesHolder.getInstance(this).apply {
            init(BuildConfig.APPLICATION_ID, BuildConfig.VERSION_NAME, BuildConfig.VERSION_CODE)
        }

        // Init runtime data holder
        runtimeDataHolder = RuntimeDataHolder.init(this, BuildConfig.DEBUG)

        // Sets the drawable resource id for login page logo
        loginLogoDrawable = R.drawable.logo

        // Sets the menu resource id for bottom navigation
        bottomNavigationMenu = R.menu.bottom_nav

        // Sets navigation graphs id list for navigation
        navGraphIds = listOf(
            {{#tableNames_navigation}}
            R.navigation.{{nameLowerCase}},
            {{/tableNames_navigation}}
            R.navigation.settings
        )
    }
}
