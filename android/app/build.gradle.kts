// android/app/build.gradle.kts
import com.android.build.gradle.internal.cxx.configure.gradleLocalProperties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")      // ✅ must be AFTER Android/Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")   // Flutter plugin always last
}

android {
    namespace = "com.example.fishpond"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.fyp" // ← change if you’ve added a custom package name in Firebase
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: create a real signingConfig before publishing
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

    }
    kotlinOptions { jvmTarget = "11" }
}

flutter { source = "../.." }

// ----------------------------------------------------------------------------
// 🔑  Dependencies
// ----------------------------------------------------------------------------
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.0")) // keep up‑to‑date
    implementation("com.google.firebase:firebase-messaging")            // push notifications
    // Add other Firebase libs here if needed (auth, firestore, etc.)
}
