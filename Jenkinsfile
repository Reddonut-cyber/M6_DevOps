pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
        stage('Install Dependencies') {
              steps {
                   sh "go mod tidy"
              }
        }
        stage('Test') {
              steps {
                   sh "go test ./..."
              }
        }
        stage('Build') {
            steps {
                sh "go build main.go"
            }
        }
        stage('Deploy') {
          steps {
              withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                sh 'ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@target "sudo systemctl stop myapp" || true' 
                sh 'scp -o StrictHostKeyChecking=no -i ${FILENAME} main ${USERNAME}@target:'
            }
          }
        }
    }
}
