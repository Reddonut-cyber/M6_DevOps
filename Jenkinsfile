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
        stage('Build Image & Push') {
            steps {
                script {
                    def imageName = "ttl.sh/reddonut-app:2h"
                    
                    sh "docker build . -t ${imageName}"
                    sh "docker push ${imageName}"
                }
            }
        }
        stage('Deploy to Docker VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'KEY_FILE', usernameVariable: 'USER')]) {
                    script {
                        def imageName = "ttl.sh/reddonut-app:2h"
                        
                        sh 'mkdir -p ~/.ssh'
                        sh 'ssh-keyscan -H docker >> ~/.ssh/known_hosts'
                        sh """
                            ssh -i \$KEY_FILE -o StrictHostKeyChecking=no \$USER@docker "docker pull ${imageName} && docker stop myapp || true && docker rm myapp || true && docker run -d -p 4444:4444 --name myapp ${imageName}"
                        """
                    }
                }
            }
        }
    }
}
