pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    plugins {
        id("com.android.application") version "8.1.0" apply false
        id("org.jetbrains.kotlin.android") version "1.9.0" apply false
        id("com.google.gms.google-services") version "4.4.2" apply false
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "aiwall"
include(":app")

// Build katalogini sozlash
rootProject.buildDir = file("build")

// Subprojects uchun build katalogini sozlash
includeBuild(rootProject.projectDir) {
    subprojects {
        buildDir = file("${rootProject.buildDir}/${project.name}")
    }
}

// Clean taskini qayta ro‘yxatdan o‘tkazish
tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}