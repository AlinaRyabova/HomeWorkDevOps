pipelineJob("goit-django-docker") {
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url(${github_repo_url})
            credentials("github-token")
          }
          branches("*/final-project")
        }
      }
      scriptPath("Jenkinsfile")
    }
  }
}