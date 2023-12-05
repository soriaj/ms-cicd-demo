pipeline {
  agent any
  environment {
    MULE_VERSION = '4.5.2'
    WORKER = 'Micro' // Used for CloudHub 1.0
    APP = 'cicddemo-v1'
    USER = credentials('username')
    PASSWORD = credentials('password')
  }
  stages {
    stage('Declarative: Checkout SCM'){
       steps {
           git branch: 'main', credentialsId: 'jenkins_ssh', url: 'git@github.com:soriaj/PATH.git'
       }
    }

    stage('Build Application') {
      steps {
            sh 'mvn clean package -B -U -e -V -X -s .maven/settings.xml -DskipTests -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }

    stage('Test') {
      steps {
            sh 'mvn test'
      }
      post {
          always {
            publishHTML (target: [
                          allowMissing: false,
                          alwaysLinkToLastBuild: false,
                          keepAll: true,
                          reportDir: 'target/site/munit/coverage',
                          reportFiles: 'summary.html',
                          reportName: "Code coverage"
                      ]
                    )
          }
        }
      }

    stage('Upload to Exchange') {
      steps {
          sh 'mvn deploy -B -U -e -V -X -s .maven/settings.xml -DskipTests -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }
    
    stage('Deploy to Development') {
      environment {
        ENVIRONMENT = 'Sandbox'
        APP_NAME = 'sandbox-${APP}'
        REGION = 'Cloudhub-US-West-1'
      }
      steps {
          sh 'mvn deploy -B -U -e -V -X -s .maven/settings.xml -DskipTests -DmuleDeploy -DmuleVersion=${MULE_VERSION} -Denvironment=${ENVIRONMENT} -DappName=${APP_NAME} -Dregion=${REGION} -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }

    stage('Integration Test') {
      steps {
          sh 'bat integration-tests --config=devx'
      }
      post {
        always {
          publishHTML (target: [
                          allowMissing: false,
                          alwaysLinkToLastBuild: true,
                          keepAll: true,
                          reportDir: '/tmp',
                          reportFiles: 'index.html',
                          reportName: "Integration Test",
                          includes: '**/index.html'
                      ]
                    )
        }
      }
    }
    stage('Deploy to Production') {
      environment {
        ENVIRONMENT = 'Production'
        APP_NAME = 'production-${APP}'
        REGION = 'Cloudhub-US-West-1'
      }
      steps {
          sh 'mvn deploy -B -U -e -V -X -s .maven/settings.xml -DskipTests -DmuleDeploy -DmuleVersion=${MULE_VERSION} -Denvironment=${ENVIRONMENT} -DappName=${APP_NAME} -Dregion=${REGION} -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }

    stage('Install Functional Monitoring') {
        steps {
            sh 'bat schedule endpoint https://production-${APP}-bmb93u.scqos5-1.usa-w1.cloudhub.io/api/product --name=production-${APP} --email-list=jsoria@salesforce.com --location=us-east-1'
        }
    }
  }
}