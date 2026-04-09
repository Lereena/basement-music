import org.gradle.api.file.Directory
import org.gradle.api.tasks.compile.JavaCompile

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

gradle.projectsEvaluated {
    allprojects {
        tasks.withType<JavaCompile>().configureEach {
            val filtered = options.compilerArgs.filter { it != "-Werror" }.toMutableList()
            if (!filtered.contains("-Xlint:-options")) {
                filtered.add("-Xlint:-options")
            }
            options.compilerArgs = filtered
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
