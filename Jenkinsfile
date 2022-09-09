pipeline {

  agent any
  environment {
    //adding a comment for the commit test
    MULE_VERSION = '4.4.0'
    BG = "SAIF Workshop 2 Day"
    WORKER = "Micro"
  }
  stages {
    stage('Build') {
      steps {
            "mvn -B -U -e -V -X clean -DskipTests package"
      }
    }

    stage('Test') {
      steps {
            "mvn test"
      }
    }

    stage('Deploy Development') {
      environment {
        ENVIRONMENT = 'Sandbox'
        APP_NAME = 'sandbox-omni-channel-api-js'
      }
      steps {
            "mvn -B -U -e -V -X clean package deploy -DmuleDeploy -Dusername=$USERNAME -Dpassword=$PASSWORD -DmuleVersion=$MULE_VERSION -Denvironment=$ENVIRONMENT -DappName=$APP_NAME -DworkerType=MICRO"
      }
    }
  }
}