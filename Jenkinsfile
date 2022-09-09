pipeline {

  agent any
  environment {
    //adding a comment for the commit test
    MULE_VERSION = '4.4.0'
    WORKER = "Micro"
  }
  stages {
    stage('Build') {
      steps {
            sh 'mvn -B -U -e -V -X clean -DskipTests package'
      }
    }

    stage('Test') {
      steps {
            sh 'mvn test'
      }
    }

    stage('Deploy Development') {
      environment {
        ENVIRONMENT = 'Sandbox'
        APP_NAME = 'sandbox-{appName}-{initials}'
      }
      steps {
            sh 'mvn -B -U -e -V -X clean package deploy -DmuleDeploy -Dusername=$USERNAME -Dpassword=$PASSWORD -DmuleVersion=$MULE_VERSION -Denvironment=$ENVIRONMENT -DappName=$APP_NAME -DworkerType=$WORKER'
      }
    }
    // make sure production environment is available or change name
    stage('Deploy Production') {
      environment {
        ENVIRONMENT = 'Production'
        APP_NAME = 'production-{appName}-{initials}'
      }
      steps {
            sh 'mvn -B -U -e -V -X clean package deploy -DmuleDeploy -Dusername=$USERNAME -Dpassword=$PASSWORD -DmuleVersion=$MULE_VERSION -Denvironment=$ENVIRONMENT -DappName=$APP_NAME -DworkerType=$WORKER'
      }
    }
  }
}