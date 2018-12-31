pipeline {
  agent any
  stages {
    stage('Build & Deploy') {
      stages {
        stage('Frontend-Prod') {          
          when {
            branch 'master'
          }
          agent { 
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint="" -v /var/jenkins_home/.cache:/home/node/.cache'
            }
          }
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              checkout scm                      
              sh 'cd ui && yarn install --network-timeout=99999'
              sh 'cd ui && ng build --configuration=production'
            }
          }
        } 
        stage('Frontend-Staging') {          
          when {
            branch 'staging'
          }
          agent { 
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint="" -v /var/jenkins_home/.cache:/home/node/.cache'
            }
          }
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              checkout scm                      
              sh 'cd ui && yarn install --network-timeout=99999'
              sh 'cd ui && ng build --configuration=staging'
            }
          }
        }
        stage('Frontend-Development') {          
          when {
            branch 'development'
          }
          agent { 
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint="" -v /var/jenkins_home/.cache:/home/node/.cache'
            }
          }
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              checkout scm                      
              sh 'cd ui && yarn install --network-timeout=99999'
              sh 'cd ui && ng build --configuration=development'
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
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              withDockerRegistry(credentialsId: 'docker-hub', url: 'https://index.docker.io/v1/') {
                sh "docker build . -t goangular-app-${BRANCH_NAME}:${GIT_COMMIT} -f Dockerfile.app"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} zeppelinops/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker tag goangular-app-${BRANCH_NAME}:${GIT_COMMIT} zeppelinops/goangular-app-${BRANCH_NAME}:latest"
                sh "docker push zeppelinops/goangular-app-${BRANCH_NAME}:${GIT_COMMIT}"
                sh "docker push zeppelinops/goangular-app-${BRANCH_NAME}:latest"
              }
            }                        
          }
        }
        stage('Deploy-Prod') {
          when {
            branch 'master'
          }          
          agent {
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint=""'
            }
          }          
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              sh "envsubst < Dockerrun.aws.json.template > Dockerrun.aws.json"
              sh "zip -r -j zeppelinops-demo-app-${GIT_COMMIT}.zip Dockerrun.aws.json"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip proxy/*"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip ui/dist/goangular-app"              
              sh "aws s3 mb s3://zeppelinops-demo-app --region us-east-1"
              sh "aws s3 cp zeppelinops-demo-app-${GIT_COMMIT}.zip s3://zeppelinops-demo-app --region us-east-1"  
              sh '''
                aws elasticbeanstalk create-application-version --application-name zeppelinops-demo-app \
                --version-label "master-${GIT_COMMIT}" \
                --source-bundle S3Bucket="zeppelinops-demo-app",S3Key="zeppelinops-demo-app-${GIT_COMMIT}.zip" --region us-east-1
              '''
              sh '''
                aws elasticbeanstalk update-environment --application-name zeppelinops-demo-app \
                --environment-name zeppelinops-demo-app-production \
                --version-label "master-${GIT_COMMIT}" --region us-east-1
              '''               
            }                        
          }
        }
        stage('Deploy-Staging') {
          when {
            branch 'staging'
          }          
          agent {
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint=""'
            }
          }          
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              sh "envsubst < Dockerrun.aws.json.template > Dockerrun.aws.json"
              sh "zip -r -j zeppelinops-demo-app-${GIT_COMMIT}.zip Dockerrun.aws.json"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip proxy/*"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip ui/dist/goangular-app"                
              sh "aws s3 mb s3://zeppelinops-demo-app --region us-east-1"
              sh "aws s3 cp zeppelinops-demo-app-${GIT_COMMIT}.zip s3://zeppelinops-demo-app --region us-east-1"  
              sh '''
                aws elasticbeanstalk create-application-version --application-name zeppelinops-demo-app \
                --version-label "master-${GIT_COMMIT}" \
                --source-bundle S3Bucket="zeppelinops-demo-app",S3Key="zeppelinops-demo-app-${GIT_COMMIT}.zip" --region us-east-1
              '''
              sh '''
                aws elasticbeanstalk update-environment --application-name zeppelinops-demo-app \
                --environment-name zeppelinops-demo-app-staging \
                --version-label "master-${GIT_COMMIT}" --region us-east-1
              '''               
            }                        
          }
        }
        stage('Deploy-Development') {
          when {
            branch 'development'
          }          
          agent {
            docker { 
              image 'zeppelinops/aws-angular:latest'
              args '--entrypoint=""'
            }
          }          
          steps {
            ws("/var/jenkins/goangular-${BRANCH_NAME}-${GIT_COMMIT}") {
              sh "envsubst < Dockerrun.aws.json.template > Dockerrun.aws.json"
              sh "zip -r -j zeppelinops-demo-app-${GIT_COMMIT}.zip Dockerrun.aws.json"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip proxy/*"
              sh "zip -r zeppelinops-demo-app-${GIT_COMMIT}.zip ui/dist/goangular-app"                
              sh "aws s3 mb s3://zeppelinops-demo-app --region us-east-1"
              sh "aws s3 cp zeppelinops-demo-app-${GIT_COMMIT}.zip s3://zeppelinops-demo-app --region us-east-1"  
              sh '''
                aws elasticbeanstalk create-application-version --application-name zeppelinops-demo-app \
                --version-label "master-${GIT_COMMIT}" \
                --source-bundle S3Bucket="zeppelinops-demo-app",S3Key="zeppelinops-demo-app-${GIT_COMMIT}.zip" --region us-east-1
              '''
              sh '''
                aws elasticbeanstalk update-environment --application-name zeppelinops-demo-app \
                --environment-name zeppelinops-demo-app-development \
                --version-label "master-${GIT_COMMIT}" --region us-east-1
              '''               
            }                        
          }
        }
      }      
    }
  }
}