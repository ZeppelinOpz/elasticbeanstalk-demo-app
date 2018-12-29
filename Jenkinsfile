pipeline {
  agent any
  stages {
    stage('Build') {
      stages {
        stage('Backend') {
          agent {
            docker { 
              image 'docker/compose:1.21.0'
              args '--entrypoint=""'
            }
          }          
          steps {
            ws("/var/jenkins/goangular") {
              checkout scm
              withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                sh "docker build . -t goangular-app-${BRANCH_NAME}:${GIT_COMMIT} -f Dockerfile.local"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} ugurkavcu/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} ugurkavcu/goangular-app-${BRANCH_NAME}:latest"
                sh "docker push ugurkavcu/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker push ugurkavcu/goangular-app-${BRANCH_NAME}:latest"
              }
            }                        
          }
        }
      }      
    }
  }
}