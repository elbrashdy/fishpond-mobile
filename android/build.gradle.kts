// Top-level build file where you can add configuration options common to all sub-projects/modules.

buildscript {
    repositories {
        google()       // ✅ Needed for Firebase plugins
        mavenCentral() // ✅ Good practice to include both
    }

    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // ✅ Firebase plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Set custom build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ✅ Make sure app subproject is evaluated before others
subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
