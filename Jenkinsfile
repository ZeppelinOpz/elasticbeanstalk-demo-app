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
    stage('Build Frontend') {
      agent { 
        docker { 
          image 'ugurkavcu/aws-angular:latest'
        }
      }
      steps {    
        dir('ui') {
          sh 'ng build'
        }
      }      
    }
    stage('Build Backend') {
      agent { 
        docker { 
          image 'docker/compose:1.21.0'
          args '--entrypoint=""'
        }
      }
      steps {
        withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
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