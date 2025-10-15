plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")   // prefer the canonical id
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.record"
    compileSdk = flutter.compileSdkVersion   // make sure this is 34+

    ndkVersion = flutter.ndkVersion

    compileOptions {
        // 👉 move to Java 17 and enable desugaring
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.record"

        // 👉 ensure minSdk >= 21 for flutter_local_notifications
        // If your flutter.minSdkVersion is < 21, set this to 21 explicitly:
        minSdk = maxOf(flutter.minSdkVersion, 21)

        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 👉 required for coreLibraryDesugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
