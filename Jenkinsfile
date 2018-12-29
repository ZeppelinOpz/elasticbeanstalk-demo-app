pipeline {
  agent {
    label {
            label ""
            customWorkspace "/var/jenkins/goangular"
        }
  }
  options {
    skipDefaultCheckout true

  }
  stages {
    stage('Init') {
      steps {
        script {
          def GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        }       
      }
    }
    stage('Build') {
      stages {
        stage('Frontend') {
          agent { 
            docker { 
              image 'ugurkavcu/aws-angular:latest'
              args '--entrypoint="" -v /var/jenkins/.cache:/home/node/.cache'
            }
          }
          steps {
            sh 'cd ui && yarn install --network-timeout=99999'
            sh 'cd ui && ng build'
          }
        }
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