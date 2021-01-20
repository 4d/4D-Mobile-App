/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{prefix}}.{{company}}.{{app_name}}.app

import com.qmobile.qmobileapi.auth.AuthInfoHelper
import com.qmobile.qmobiledatastore.db.AppDatabaseFactory
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobileui.utils.ApplicationUtils
import com.qmobile.qmobileui.utils.DeviceUtils
import com.qmobile.qmobileui.utils.FileUtils
import com.qmobile.qmobileui.utils.FileUtils.EMBEDDED_PICTURES
import com.qmobile.qmobileui.utils.FileUtils.EMBEDDED_PICTURES_PARENT
import com.qmobile.qmobileui.utils.LogController
import {{prefix}}.{{company}}.{{app_name}}.BuildConfig
import {{prefix}}.{{company}}.{{app_name}}.R
import {{prefix}}.{{company}}.{{app_name}}.data.db.AppDatabase
import {{prefix}}.{{company}}.{{app_name}}.utils.FromTableForViewModelImpl
import {{prefix}}.{{company}}.{{app_name}}.utils.NavigationImpl
import {{prefix}}.{{company}}.{{app_name}}.utils.ViewDataBindingImpl
import {{prefix}}.{{company}}.{{app_name}}.utils.getPropertyListFromTable
import org.json.JSONObject
import java.io.File

class App : BaseApp() {

    override fun onCreate() {
        super.onCreate()

        // Sets the drawable resource id for login page logo
        loginLogoDrawable = R.drawable.logo_4d

        // Sets the menu resource id for bottom navigation
        bottomNavigationMenu = R.menu.bottom_nav

        // Sets navigation graphs id list for navigation
        navGraphIds = listOf(
            {{#tableNames_navigation}}
            R.navigation.{{nameLowerCase}},
            {{/tableNames_navigation}}
            R.navigation.settings
        )

        // Sets interfaces to get data coming from outside the SDK
        appDatabaseInterface =
            AppDatabaseFactory.getAppDatabase(applicationContext, AppDatabase::class.java)
        fromTableForViewModel = FromTableForViewModelImpl()
        navigationInterface = NavigationImpl()
        viewDataBindingInterface = ViewDataBindingImpl()

        // Setup logging
        LogController.initialize(this)

        // As a first step, we gather information about the app and build information
        saveEnvironmentInfo()
        saveTableQueries()
        saveTableProperties()

        // Get list of embedded images
        embeddedFiles = getEmbeddedImages()
    }

    /**
     * Gets information on the app, device, team etc, and fills it in SharedPreferences
     */
    private fun saveEnvironmentInfo() {
        val manifest = ApplicationUtils.getManifest(this)
        AuthInfoHelper.getInstance(this).apply {
            appInfo = getAppInfo()
            device = DeviceUtils.getDeviceInfo(this@App)
            team = ApplicationUtils.getTeamInfo(manifest)
            language = DeviceUtils.getLanguageInfo()
            guestLogin = ApplicationUtils.getGuestLogin(manifest)
            remoteUrl = ApplicationUtils.getRemoteUrl(manifest)
            embeddedData = ApplicationUtils.getEmbeddedData(manifest)
            globalStamp = ApplicationUtils.getInitialGlobalStamp(manifest)
        }
    }

    /**
     * Gets app info from BuildConfig
     */
    private fun getAppInfo(): JSONObject {
        return JSONObject().apply {
            put(
                ApplicationUtils.APPLICATION_ID,
                BuildConfig.APPLICATION_ID
            ) // com.qmobile.sample4dapp
            put(ApplicationUtils.APPLICATION_NAME, BuildConfig.VERSION_NAME) // 1.0
            put(ApplicationUtils.APPLICATION_VERSION, BuildConfig.VERSION_CODE) // 1
        }
    }

    private fun saveTableQueries() {
        val queriesJson = ApplicationUtils.getQueries(this)
        AuthInfoHelper.getInstance(this).setQueries(queriesJson)
    }

    private fun saveTableProperties() {
        for (tableName in fromTableForViewModel.tableNames()) {
            val properties = getPropertyListFromTable(tableName, this)
            AuthInfoHelper.getInstance(this).setProperties(tableName, properties)
        }
    }

    private fun getEmbeddedImages(): List<String> =
        FileUtils.listAssetFiles(
            EMBEDDED_PICTURES_PARENT + File.separator + EMBEDDED_PICTURES,
            this
        )
            .filter { !it.endsWith(FileUtils.JSON_EXT) }
}
