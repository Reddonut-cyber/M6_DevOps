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
                sh "docker build . --tag ttl.sh/reddonut:1h"
            }
        }
        stage('Build Push Image') {
            steps {
                sh "docker push ttl.sh/reddonut:1h"
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: 'apikey', serverUrl: 'https://kubernetes:6443']) {
                    sh 'kubectl apply -f pod.yaml'
                    sh 'kubectl apply -f service.yaml'
                }
            }
        }
    }
}
