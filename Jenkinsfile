pipeline {
    agent any
  
    tools {
        nodejs 'node24'
    }

    stages {
        stage('Install packages') {
            steps {
                sh 'npm install'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build --tag ttl.sh/reddonut:1h .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push ttl.sh/reddonut:1h'        
            }
        }

        stage('Deploy') {
            parallel {
                stage('Deploy to target') {
                    steps {
                        withCredentials([sshUserPrivateKey(credentialsId: 'targetkey', keyFileVariable: 'KEYFILE', usernameVariable: 'USERNAME')]) {
                            sh '''
                                ansible-playbook --inventory=./target/host.ini \
                                --private-key=${KEYFILE} \
                                -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
                                ./target/playbook.yml
                            '''
                        }
                    }
                }

                stage('Deploy to docker') {
                    steps {
                        withCredentials([sshUserPrivateKey(credentialsId: 'dockerkey', keyFileVariable: 'KEYFILE', usernameVariable: 'USERNAME')]) {
                            sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@docker 'docker pull ttl.sh/reddonut:1h'"
                            sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@docker 'docker rm -f myapp || true'"
                            sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@docker 'docker run --rm -dit --name myapp -p 4444:4444 ttl.sh/reddonut:1h'"
                        }
                    }          
                }

                stage('Deploy to kubernetes') {
                    steps {
                        withCredentials([sshUserPrivateKey(credentialsId: 'kuberneteskey', keyFileVariable: 'KEYFILE', usernameVariable: 'USERNAME')]) {
                            script {
                                sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@kubernetes 'kubectl delete pod myapp || true'"
                                sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@kubernetes 'kubectl delete service myapp-service || true'"
                                
                                
                                sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@kubernetes 'kubectl run myapp --image=ttl.sh/reddonut:1h --restart=Never --port=4444 --labels=app=myapp'"
                                
                                sh "ssh -o StrictHostKeyChecking=no -i ${KEYFILE} ${USERNAME}@kubernetes 'kubectl expose pod myapp --type=NodePort --port=4444 --name=myapp-service'"
                            }
                        }
                    }
                }
            }
        }
    }
}