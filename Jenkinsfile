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
    }
    stage('Upload to Exchange') {
      steps {
          sh 'mvn deploy -B -U -e -V -X -s .maven/settings.xml -DskipTests -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }
    
    stage('Deploy to Sandbox') {
      environment {
        ENVIRONMENT = 'Sandbox'
        APP_NAME = 'sandbox-${APP}'
        REGION = 'Cloudhub-US-West-1'
      }
      steps {
          sh 'mvn deploy -B -U -e -V -X -s .maven/settings.xml -DskipTests -DmuleDeploy -DmuleVersion=${MULE_VERSION} -Denvironment=${ENVIRONMENT} -DappName=${APP_NAME} -Dregion=${REGION} -Dusername=${USER} -Dpassword=${PASSWORD}'
      }
    }
  }
}