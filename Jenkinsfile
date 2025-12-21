pipeline {
    agent any

    tools {
       go "1.24.1"
    }

    environment {
        AWS_IP = "3.73.117.173"
    }

    stages {
        stage('Test') {
              steps {
                   sh "go test ./..."
              }
        }

        stage('Build') {
            steps {
                sh "go build -o main main.go"
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build . --tag ttl.sh/reddonut:1h"
            }
        }

        stage('Build Push Image') {
            steps {
                sh "docker push ttl.sh/reddonut:1h"
            }
        }

        stage('Deploy to AWS') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'aws-key', keyFileVariable: 'KEY', usernameVariable: 'USER')]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no -i ${KEY} ${USER}@${AWS_IP} 'pkill main || true'

                        scp -o StrictHostKeyChecking=no -i ${KEY} main ${USER}@${AWS_IP}:/home/${USER}/main

                        ssh -o StrictHostKeyChecking=no -i ${KEY} ${USER}@${AWS_IP} '
                            chmod +x main
                            nohup ./main > output.log 2>&1 &
                        '
                    """
                }
            }
        }
    }
}
