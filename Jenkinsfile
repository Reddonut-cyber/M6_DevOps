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
                withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'KEY_FILE', usernameVariable: 'USER')]) {
                    
                    sh 'mkdir -p ~/.ssh'
                    
                    sh 'ssh-keyscan -H target >> ~/.ssh/known_hosts'

                    sh 'ansible-playbook -i hosts.ini playbook.yml --private-key $KEY_FILE'
                }
            }
        }
    }
}
