pipeline {
  agent any
  stages {
    stage('Build') {
      stages {
        stage('Frontend') {
          agent { 
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint="" -v /var/jenkins_home/.cache:/home/node/.cache'
            }
          }
          steps {
            ws("/var/jenkins/goangular") {
              checkout scm                      
              sh 'cd ui && yarn install --network-timeout=99999'
              sh 'cd ui && ng build'
            }
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
            ws("/var/jenkins/goangular") {
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
        stage('Deploy Production') {
          agent {
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint=""'
            }
          }          
          steps {
            ws("/var/jenkins/goangular") {
              sh "envsubst < Dockerrun.aws.json.template > Dockerrun.aws.json"
              sh "aws s3 ls"
            }                        
          }
        }        
      }      
    }
  }
}