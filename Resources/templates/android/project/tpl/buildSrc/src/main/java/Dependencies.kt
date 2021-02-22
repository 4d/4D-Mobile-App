/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

import org.gradle.api.JavaVersion

object Versions {
    // QMobile libraries
    val qmobileapi = "0.0.1"
    val qmobiledatastore = "0.0.1"
    val qmobiledatasync = "0.0.1"
    val qmobileui = "0.0.1"

    val android_gradle_plugin = "3.5.2"
    val arch_core = "2.1.0"
    val artifactory = "4.20.0"
    val atsl_junit = "1.1.2"
    val constraint_layout = "2.0.4"
    val design = "1.2.0"
    val espresso = "3.2.0"
    val espresso_contrib = "3.0.2"
    val glide = "4.12.0"
    val junit = "4.13.1"
    val kotlin = "1.4.10"
    val leakcanary = "2.0"
    val lifecycle = "2.2.0"
    val mockito = "3.7.7"
    val multidex = "2.0.1"
    val navigation = "2.3.0"
    val okhttp = "4.9.0"
    val preference = "1.1.1"
    val retrofit = "2.9.0"
    val robolectric = "4.5.1"
    val room = "2.2.5"
    val rules = "1.3.0"
    val runner = "1.3.0"
    val rx_android = "2.1.1"
    val rxjava2 = "2.2.20"
    val sqlite = "2.1.0"
    val support = "1.2.0"
    val swiperefreshlayout = "1.1.0"
    val timber = "4.7.1"
}

object Config {
    val buildTools = "29.0.2"
    val compileSdk = 29
    val minSdk = 21
    val targetSdk = 29
    val javaVersion = JavaVersion.VERSION_1_8
}

object Tools {
    val artifactory = "org.jfrog.buildinfo:build-info-extractor-gradle:${Versions.artifactory}"
    val gradle = "com.android.tools.build:gradle:${Versions.android_gradle_plugin}"
    val kotlin_allopen_plugin = "org.jetbrains.kotlin:kotlin-allopen:${Versions.kotlin}"
    val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    val navigation_safe_args_gradle_plugin =
        "androidx.navigation:navigation-safe-args-gradle-plugin:${Versions.navigation}"
}

object QMobileLibs {
    val qmobileapi =
        "com.qmobile.qmobileapi:qmobileapi:${Versions.qmobileapi}"
    val qmobiledatastore =
        "com.qmobile.qmobiledatastore:qmobiledatastore:${Versions.qmobiledatastore}"
    val qmobiledatasync =
        "com.qmobile.qmobiledatasync:qmobiledatasync:${Versions.qmobiledatasync}"
    val qmobileui =
        "com.qmobile.qmobileui:qmobileui:${Versions.qmobileui}"
}

object Libs {

    // Common
    val androidx_appcompat = "androidx.appcompat:appcompat:${Versions.support}"
    val androidx_preference_ktx = "androidx.preference:preference-ktx:${Versions.preference}"
    val multidex = "androidx.multidex:multidex:${Versions.multidex}"
    val kotlin_reflect = "org.jetbrains.kotlin:kotlin-reflect:${Versions.kotlin}"
    val kotlin_stdlib = "org.jetbrains.kotlin:kotlin-stdlib:${Versions.kotlin}"

    // Common + Layout
    val androidx_constraintlayout =
        "androidx.constraintlayout:constraintlayout:${Versions.constraint_layout}"
    val material = "com.google.android.material:material:${Versions.design}"
    val swiperefreshlayout =
        "androidx.swiperefreshlayout:swiperefreshlayout:${Versions.swiperefreshlayout}"

    // Room
    val androidx_room = "androidx.room:room-ktx:${Versions.room}"
    val androidx_room_runtime = "androidx.room:room-runtime:${Versions.room}"
    val androidx_room_compiler = "androidx.room:room-compiler:${Versions.room}"

    // Glide
    val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"

    // Lifecycle
    val lifecycle_compiler = "androidx.lifecycle:lifecycle-compiler:${Versions.lifecycle}"
    val lifecycle_extensions = "androidx.lifecycle:lifecycle-extensions:${Versions.lifecycle}"
    val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime:${Versions.lifecycle}"
    val lifecyle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"

    // OkHttp
    val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    val okhttp_logging_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"
    val okhttp_mockwebserver = "com.squareup.okhttp3:mockwebserver:${Versions.okhttp}"

    // Retrofit
    val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    val retrofit_adapter_rxjava2 = "com.squareup.retrofit2:adapter-rxjava2:${Versions.retrofit}"

    //    val retrofit_adapter_rxjava2 = "com.squareup.retrofit2:adapter-rxjava3:${Versions.retrofit}"
    val retrofit_converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"

    // Rx
    val rxandroid = "io.reactivex.rxjava2:rxandroid:${Versions.rx_android}"
    val rxjava = "io.reactivex.rxjava2:rxjava:${Versions.rxjava2}"

    // Navigation
    val androidx_navigation_fragment =
        "androidx.navigation:navigation-fragment-ktx:${Versions.navigation}"
    val androidx_navigation_ui = "androidx.navigation:navigation-ui-ktx:${Versions.navigation}"

    // Utils
    val leakcanary = "com.squareup.leakcanary:leakcanary-android:${Versions.leakcanary}"
    val timber = "com.jakewharton.timber:timber:${Versions.timber}"

    // Testing - Unit
    val androidx_core_testing = "androidx.arch.core:core-testing:${Versions.arch_core}"
    val androidx_espresso = "androidx.test.espresso:espresso-core:${Versions.espresso}"
    val androidx_junit = "androidx.test.ext:junit:${Versions.atsl_junit}"
    val androidx_junit_ktx = "androidx.test.ext:junit-ktx:${Versions.atsl_junit}"
    val androidx_room_testing = "androidx.room:room-testing:${Versions.room}"
    val androidx_rules = "androidx.test:rules:${Versions.rules}"
    val androidx_runner = "androidx.test:runner:${Versions.runner}"
    val espresso_contrib =
        "com.android.support.test.espresso:espresso-contrib:${Versions.espresso_contrib}"
    val junit = "junit:junit:${Versions.junit}"
    val mockito = "org.mockito:mockito-core:${Versions.mockito}"
    val mockito_android = "org.mockito:mockito-android:${Versions.mockito}"
    val robolectric = "org.robolectric:robolectric:${Versions.robolectric}"
}
