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
                sh "go build -o main main.go"
            }
        }
        stage('Deploy') {
            steps {
                script {
                    def imageName = "ttl.sh/reddonut-app:2h"
                    
                    sh "docker build . -t ${imageName}"
                    
                    sh "docker push ${imageName}"
                }
            }
        }
    }
}
