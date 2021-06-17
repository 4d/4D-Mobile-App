/*
 * Created by {{author}} on {{date_day}}/{{date_month}}/{{date_year}}.
 * {{company_header}}
 * Copyright (c) {{date_year}} {{author}}. All rights reserved.
 */

import org.gradle.api.JavaVersion

object Versions {
    // QMobile libraries
    const val qmobileapi = "0.0.1"
    const val qmobiledatastore = "0.0.1"
    const val qmobiledatasync = "0.0.1"
    const val qmobileui = "0.0.1"

    const val android_gradle_plugin = "4.2.0"
    const val arch_core = "2.1.0"
    const val artifactory = "4.24.4"
    const val atsl_junit = "1.1.2"
    const val constraint_layout = "2.0.4"
    const val design = "1.3.0"
    const val dynamic_toasts = "3.3.1"
    const val espresso = "3.2.0"
    const val espresso_contrib = "3.0.2"
    const val glide = "4.12.0"
    const val glide_transformations = "4.3.0"
    const val jackson = "2.12.3"
    const val json = "20180813"
    const val junit = "4.13.2"
    const val kotlin = "1.5.10"
    const val kotlin_coroutines = "1.5.0"
    const val leakcanary = "2.0"
    const val lifecycle = "2.3.1"
    const val mockito = "3.11.1"
    const val mockk = "1.11.0"
    const val multidex = "2.0.1"
    const val navigation = "2.3.5"
    const val okhttp = "4.9.0"
    const val paging = "2.1.2"
    const val preference = "1.1.1"
    const val retrofit = "2.9.0"
    const val robolectric = "4.5.1"
    const val room = "2.3.0"
    const val rules = "1.3.0"
    const val runner = "1.3.0"
    const val rx_android = "2.1.1"
    const val rxjava2 = "2.2.21"
    const val sqlite = "2.1.0"
    const val support = "1.2.0"
    const val swiperefreshlayout = "1.1.0"
    const val timber = "4.7.1"
}

object Config {
    const val buildTools = "30.0.2"
    const val compileSdk = 30
    const val minSdk = 21
    const val targetSdk = 30
    val javaVersion = JavaVersion.VERSION_1_8
}

object Tools {
    const val artifactory = "org.jfrog.buildinfo:build-info-extractor-gradle:${Versions.artifactory}"
    const val gradle = "com.android.tools.build:gradle:${Versions.android_gradle_plugin}"
    const val kotlin_gradle_plugin = "org.jetbrains.kotlin:kotlin-gradle-plugin:${Versions.kotlin}"
    const val navigation_safe_args_gradle_plugin =
        "androidx.navigation:navigation-safe-args-gradle-plugin:${Versions.navigation}"
}

object QMobileLibs {
    const val qmobileapi =
        "com.qmobile.qmobileapi:qmobileapi:${Versions.qmobileapi}"
    const val qmobiledatastore =
        "com.qmobile.qmobiledatastore:qmobiledatastore:${Versions.qmobiledatastore}"
    const val qmobiledatasync =
        "com.qmobile.qmobiledatasync:qmobiledatasync:${Versions.qmobiledatasync}"
    const val qmobileui =
        "com.qmobile.qmobileui:qmobileui:${Versions.qmobileui}"
}

object Libs {

    // Common
    const val androidx_appcompat = "androidx.appcompat:appcompat:${Versions.support}"
    const val androidx_preference_ktx = "androidx.preference:preference-ktx:${Versions.preference}"
    const val multidex = "androidx.multidex:multidex:${Versions.multidex}"
    const val kotlin_coroutines_android =
        "org.jetbrains.kotlinx:kotlinx-coroutines-android:${Versions.kotlin_coroutines}"
    const val kotlin_coroutines_core =
        "org.jetbrains.kotlinx:kotlinx-coroutines-core:${Versions.kotlin_coroutines}"
    const val kotlin_reflect = "org.jetbrains.kotlin:kotlin-reflect:${Versions.kotlin}"
    const val kotlin_stdlib = "org.jetbrains.kotlin:kotlin-stdlib:${Versions.kotlin}"

    // Common + Layout
    const val androidx_constraintlayout =
        "androidx.constraintlayout:constraintlayout:${Versions.constraint_layout}"
    const val material = "com.google.android.material:material:${Versions.design}"
    const val swiperefreshlayout =
        "androidx.swiperefreshlayout:swiperefreshlayout:${Versions.swiperefreshlayout}"

    // Room
    const val androidx_room = "androidx.room:room-ktx:${Versions.room}"
    const val androidx_room_runtime = "androidx.room:room-runtime:${Versions.room}"
    const val androidx_room_compiler = "androidx.room:room-compiler:${Versions.room}"
    const val sqlite = "androidx.sqlite:sqlite-ktx:${Versions.sqlite}"

    // Glide
    const val glide = "com.github.bumptech.glide:glide:${Versions.glide}"
    const val glide_compiler = "com.github.bumptech.glide:compiler:${Versions.glide}"
    const val glide_transformations =
        "jp.wasabeef:glide-transformations:${Versions.glide_transformations}"

    // Lifecycle
    const val lifecycle_compiler = "androidx.lifecycle:lifecycle-compiler:${Versions.lifecycle}"
    const val lifecycle_livedata = "androidx.lifecycle:lifecycle-livedata-ktx:${Versions.lifecycle}"
    const val lifecycle_process = "androidx.lifecycle:lifecycle-process:${Versions.lifecycle}"
    const val lifecycle_runtime = "androidx.lifecycle:lifecycle-runtime:${Versions.lifecycle}"
    const val lifecycle_runtime_ktx = "androidx.lifecycle:lifecycle-runtime-ktx:${Versions.lifecycle}"
    const val lifecycle_viewmodel = "androidx.lifecycle:lifecycle-viewmodel-ktx:${Versions.lifecycle}"

    // OkHttp
    const val okhttp = "com.squareup.okhttp3:okhttp:${Versions.okhttp}"
    const val okhttp_logging_interceptor = "com.squareup.okhttp3:logging-interceptor:${Versions.okhttp}"
    const val okhttp_mockwebserver = "com.squareup.okhttp3:mockwebserver:${Versions.okhttp}"

    // Paging
    const val androidx_paging = "androidx.paging:paging-runtime-ktx:${Versions.paging}"

    // Retrofit
    const val retrofit = "com.squareup.retrofit2:retrofit:${Versions.retrofit}"
    const val retrofit_adapter_rxjava2 = "com.squareup.retrofit2:adapter-rxjava2:${Versions.retrofit}"

    //    const val retrofit_adapter_rxjava2 = "com.squareup.retrofit2:adapter-rxjava3:${Versions.retrofit}"
    const val retrofit_converter_gson = "com.squareup.retrofit2:converter-gson:${Versions.retrofit}"

    // Jackson
    const val jackson = "com.fasterxml.jackson.module:jackson-module-kotlin:${Versions.jackson}"

    // Rx
    const val rxandroid = "io.reactivex.rxjava2:rxandroid:${Versions.rx_android}"
    const val rxjava = "io.reactivex.rxjava2:rxjava:${Versions.rxjava2}"

    // Navigation
    const val androidx_navigation_fragment =
        "androidx.navigation:navigation-fragment-ktx:${Versions.navigation}"
    const val androidx_navigation_ui = "androidx.navigation:navigation-ui-ktx:${Versions.navigation}"

    // Utils
    const val dynamic_toasts = "com.pranavpandey.android:dynamic-toasts:${Versions.dynamic_toasts}"
    const val leakcanary = "com.squareup.leakcanary:leakcanary-android:${Versions.leakcanary}"
    const val timber = "com.jakewharton.timber:timber:${Versions.timber}"

    // Testing - Unit
    const val androidx_core_testing = "androidx.arch.core:core-testing:${Versions.arch_core}"
    const val androidx_espresso = "androidx.test.espresso:espresso-core:${Versions.espresso}"
    const val androidx_junit = "androidx.test.ext:junit:${Versions.atsl_junit}"
    const val androidx_junit_ktx = "androidx.test.ext:junit-ktx:${Versions.atsl_junit}"
    const val androidx_room_testing = "androidx.room:room-testing:${Versions.room}"
    const val androidx_rules = "androidx.test:rules:${Versions.rules}"
    const val androidx_runner = "androidx.test:runner:${Versions.runner}"
    const val espresso_contrib =
        "com.android.support.test.espresso:espresso-contrib:${Versions.espresso_contrib}"
    const val json = "org.json:json:${Versions.json}"
    const val junit = "junit:junit:${Versions.junit}"
    const val mockito = "org.mockito:mockito-core:${Versions.mockito}"
    const val mockito_android = "org.mockito:mockito-android:${Versions.mockito}"
    const val mockk = "io.mockk:mockk:${Versions.mockk}"
    const val robolectric = "org.robolectric:robolectric:${Versions.robolectric}"
}
