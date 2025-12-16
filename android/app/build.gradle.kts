import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()

// Try android/local.properties first (common in some setups), then root local.properties
val androidKeyFile = rootProject.file("android/local.properties")
val rootKeyFile = rootProject.file("local.properties")

if (androidKeyFile.exists()) {
    keystoreProperties.load(FileInputStream(androidKeyFile))
} else if (rootKeyFile.exists()) {
    keystoreProperties.load(FileInputStream(rootKeyFile))
}

// Flutter SDK check (still required)
val flutterRoot = keystoreProperties.getProperty("flutter.sdk")
    ?: throw GradleException("Flutter SDK not found. Define flutter.sdk in local.properties")

android {
    namespace = "com.example.alab"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {

            storeFile = file(keystoreProperties["signIn.File"]?.toString() ?: "")
            storePassword = keystoreProperties["signIn.storePassword"]?.toString() ?: ""
            keyAlias = keystoreProperties["signIn.keyAlias"]?.toString() ?: ""
            keyPassword = keystoreProperties["signIn.keyPassword"]?.toString() ?: ""
        }
    }

    defaultConfig {
        applicationId = "com.example.alab"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use your real release keystore
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            // Optional: you can also sign debug with release key if you want (rarely needed)
            // signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("com.google.firebase:firebase-messaging:23.4.0")
    implementation("com.google.firebase:firebase-installations:17.2.0")
}