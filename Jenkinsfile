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
              withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                sh "docker build . -t goangular-app-${BRANCH_NAME}:${GIT_COMMIT} -f Dockerfile.local"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} zeppelinops/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} zeppelinops/goangular-app-${BRANCH_NAME}:latest"
                sh "docker push zeppelinops/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker push zeppelinops/goangular-app-${BRANCH_NAME}:latest"
              }                        
          }
        }
      }      
    }
  }
}