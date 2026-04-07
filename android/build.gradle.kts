buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.12.3")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ FORCE ALL MODULES TO USE SAME SDK (CRITICAL FIX)
subprojects {

    afterEvaluate {

        extensions.findByName("android")?.let { ext ->

            ext as com.android.build.gradle.BaseExtension

            // ✅ SDK alignment
            ext.compileSdkVersion(36)

            ext.defaultConfig {
                targetSdk = 36
            }

            // ✅ Java 17
            ext.compileOptions {
                sourceCompatibility = JavaVersion.VERSION_17
                targetCompatibility = JavaVersion.VERSION_17
            }
        }

        // ✅ 🔥 FORCE Kotlin JVM TARGET = 17 (THIS FIXES YOUR ERROR)
        tasks.withType(org.jetbrains.kotlin.gradle.tasks.KotlinCompile::class.java).configureEach {
            kotlinOptions {
                jvmTarget = "17"
            }
        }
    }
}

// ✅ unify build folders (same as your old config)
rootProject.buildDir = file("../build")

subprojects {
    buildDir = file("${rootProject.buildDir}/${project.name}")
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}