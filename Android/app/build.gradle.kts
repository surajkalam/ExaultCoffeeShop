plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    //id("com.google.gms.google-services")
}

android {
    namespace = "com.example.coffee_shop"
    //compileSdk = flutter.compileSdkVersion
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  //add 19aug at FN 
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.coffee_shop"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        //minSdk = flutter.minSdkVersion
        minSdk = flutter.minSdkVersion
        //targetSdk = flutter.targetSdkVersion
        targetSdk =34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true 
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            //signingConfig signingConfigs.release
             isMinifyEnabled = false // Changed from minifyEnabled
            isShrinkResources = false // Changed from shrinkResources
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}
dependencies {
  implementation("androidx.multidex:multidex:2.0.1")

  implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
  implementation("com.google.firebase:firebase-analytics")
  implementation("com.google.firebase:firebase-auth") 
  //implementation 'com.google.android.gms:play-services-auth:20.7.0'

    // ✅ Kotlin DSL requires function-style calls
   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
   implementation("androidx.appcompat:appcompat:1.6.1")
   implementation("com.google.android.material:material:1.11.0")
   implementation("androidx.constraintlayout:constraintlayout:2.1.4")
}
