pipeline {
  agent any
  stages {
    stage('Init') {
      steps {
        script {
          def GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        }       
      }
    }
    stage('Build') {
      agent { 
        docker { 
          image 'ugurkavcu/aws-angular:latest'
          args '--entrypoint=""'
        }
      }
      steps {
        withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') { 
          dir('ui') {
            sh 'ng build'
          }            
          sh "docker build . -t goangular-app-${BRANCH}:${GIT_COMMIT} -f Dockerfile.local"
          sh "docker tag goangular-app-${BRANCH}:${GIT_COMMIT} ugurkavcu/goangular-app-${BRANCH}:${GIT_COMMIT}"
          sh "docker tag goangular-app-${BRANCH}:${GIT_COMMIT} ugurkavcu/goangular-app-${BRANCH}:latest"
          sh "docker push ugurkavcu/goangular-app-${BRANCH}:${GIT_COMMIT}"
          sh "docker push ugurkavcu/goangular-app-${BRANCH}:latest"
        }
      }
    }
  }
}