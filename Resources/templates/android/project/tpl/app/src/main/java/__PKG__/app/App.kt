/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

package {{package}}.app

import com.qmobile.qmobileapi.auth.AuthInfoHelper
import com.qmobile.qmobiledatastore.db.AppDatabaseFactory
import com.qmobile.qmobiledatasync.app.BaseApp
import com.qmobile.qmobileui.model.QMobileUiConstants
import com.qmobile.qmobileui.utils.LogController
import com.qmobile.qmobileui.utils.QMobileUiUtil
import {{package}}.BuildConfig
import {{package}}.R
import {{package}}.data.db.AppDatabase
import {{package}}.utils.FragmentUtilImpl
import {{package}}.utils.FromTableForViewModelImpl
import {{package}}.utils.NavigationImpl
import {{package}}.utils.getPropertyListFromTable
import org.json.JSONObject
import java.io.File

class App : BaseApp() {

    override fun onCreate() {
        super.onCreate()

        // QMobileUtil init
        QMobileUiUtil.builder(context = this)

        // Sets the drawable resource id for login page logo
        loginLogoDrawable = R.mipmap.ic_launcher_foreground

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
        fragmentUtil = FragmentUtilImpl()

        // Setup logging
        LogController.initialize(this)

        // As a first step, we gather information about the app and build information
        saveEnvironmentInfo()
        AuthInfoHelper.getInstance(this).setQueries(QMobileUiUtil.appUtilities.queryJson)
        saveTableProperties()

        // Get list of embedded images
        embeddedFiles =
            QMobileUiUtil.listAllFilesInAsset(QMobileUiConstants.EMBEDDED_PICTURES_PARENT
                    + File.separator + QMobileUiConstants.EMBEDDED_PICTURES)
                .filter { !it.endsWith(QMobileUiConstants.JSON_EXT) }
    }

    /**
     * Gets information on the app, device, team etc, and fills it in SharedPreferences
     */
    private fun saveEnvironmentInfo() {

        AuthInfoHelper.getInstance(this).apply {
            appInfo = JSONObject().apply {
                put(
                    "id",
                    BuildConfig.APPLICATION_ID
                ) // com.qmobile.sample4dapp
                put("name", BuildConfig.VERSION_NAME) // 1.0
                put("version", BuildConfig.VERSION_CODE) // 1
            }
            device = QMobileUiUtil.deviceUtility.deviceInfo
            team = QMobileUiUtil.appUtilities.teams
            language = QMobileUiUtil.deviceUtility.language
            guestLogin = QMobileUiUtil.appUtilities.guestLogin
            remoteUrl = QMobileUiUtil.appUtilities.remoteUrl
            embeddedData = QMobileUiUtil.appUtilities.embeddedData
            globalStamp = QMobileUiUtil.appUtilities.globalStamp
            sdkVersion = QMobileUiUtil.appUtilities.sdkVersion
        }
    }

    private fun saveTableProperties() {
        for (tableName in fromTableForViewModel.tableNames()) {
            val properties = getPropertyListFromTable(tableName, this)
            AuthInfoHelper.getInstance(this).setProperties(tableName, properties)
        }
    }
}
