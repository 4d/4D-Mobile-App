/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import com.google.android.material.color.DynamicColors
import com.google.android.material.color.DynamicColorsOptions
import com.qmobile.qmobileapi.utils.SharedPreferencesHolder
import com.qmobile.qmobiledatastore.db.AppDatabaseFactory
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobiledatasync.utils.RuntimeDataHolder
import com.qmobile.qmobileui.crash.TopExceptionHandler
import {{package}}.BuildConfig
import {{package}}.R
import {{package}}.data.db.AppDatabase
import {{package}}.utils.CustomNavigationResolver
import {{package}}.utils.CustomRelationHelper
import {{package}}.utils.CustomResourceHelper
import {{package}}.utils.CustomTableFragmentHelper
import {{package}}.utils.CustomTableHelper

class App : BaseApp() {

    override fun onCreate() {
        super.onCreate()

        System.loadLibrary("exceptions-lib")
        Thread.setDefaultUncaughtExceptionHandler(TopExceptionHandler(this))

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
        genericResourceHelper = CustomResourceHelper()

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

        if (runtimeDataHolder.pushNotification) {
            createNotificationChannel()
        }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                resources.getString(R.string.push_channel_id),
                "QMobileAndroid",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            channel.description = resources.getString(R.string.push_channel_description)

            val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
}
