pipeline {
    agent { label 'jenkins-agent' }

    environment {
        // Set your GitHub repository URL
        REPO_URL = 'https://github.com/belalelnady/Execute-script-from-jenkins'
        
        // Define the Docker image name based on the repository name
        IMAGE_NAME = 'dockerized-web-app'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                git url: "${REPO_URL}", branch: 'master'
                sh ''
            }
        }
          stage('Move Key-pair') {
            agent any 
            steps {
                sh 'sudo scp -o StrictHostKeyChecking=no -i ~/.ssh/web_app_key.pem ~/.ssh/web_app_key.pem ubuntu@3.239.105.205:/home/ubuntu'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Run Docker build for the Dockerfile in the repository
                    sh 'echo this-will-fail'
                    sh 'docker build -t ${IMAGE_NAME} .'
                }
            }
        }

        stage('Push Docker Image') {
      
            steps {
                script {
                    // Log in to Docker Hub (assuming credentials are stored in Jenkins)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                  
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        // Tag the Docker image and push to Docker Hub
                        sh 'docker tag ${IMAGE_NAME} ${DOCKER_USER}/${IMAGE_NAME}:latest'
                        sh 'docker push ${DOCKER_USER}/${IMAGE_NAME}:latest'
                    }
                }
            }
        }

           stage('Run Ansible Playbook') {
           
            steps {
                script {
                    // Run the Ansible command
                     sh 'ansible-playbook -i inventory.ini ansible-playbook.yml' 
                     // Replace with your playbook and inventory files
                   
                }
            }
        }
    }
    

    post {
        always {
            // Cleanup Docker images
            sh 'docker rmi ${IMAGE_NAME} || true'
            sh 'echo  cleaned'
        }
 }

}