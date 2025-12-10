pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    stages {
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
        stage('Build Docker Image') {
            steps {
                sh "docker build . --tag ttl.sh/myapp2:1h"
            }
        }
        stage('Build Push Image') {
            steps {
                sh "docker push ttl.sh/myapp2:1h"
            }
        }
        stage('Docker Run Image') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'mykey', keyFileVariable: 'FILENAME', usernameVariable: 'USERNAME')]) {
                  sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker stop myapp || true'"
                  sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker rm myapp || true'"
                  sh "ssh -o StrictHostKeyChecking=no -i ${FILENAME} ${USERNAME}@docker 'docker run --name myapp --pull always --detach --publish 4444:4444 ttl.sh/myapp2:1h'"
               }
            }
        }
    }
}
