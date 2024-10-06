pipeline {
    agent any

    environment {
        // Set your GitHub repository URL
        REPO_URL = 'https://github.com/belalelnady/Execute-script-from-jenkins'
        
        // Define the Docker image name based on the repository name
        IMAGE_NAME = 'Dockerized-web-app:latest'
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clone the repository
                git url: "${REPO_URL}", branch: 'master'
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
            when {
                expression {
                    // Push only if branch is main
                    return env.BRANCH_NAME == 'master'
                }
            }
            steps {
                script {
                    // Log in to Docker Hub (assuming credentials are stored in Jenkins)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin'
                        
                        // Tag the Docker image and push to Docker Hub
                        sh 'docker tag ${IMAGE_NAME} ${DOCKER_USER}/${IMAGE_NAME}:latest'
                        sh 'docker push ${DOCKER_USER}/${IMAGE_NAME}:latest'
                    }
                }
            }
        }
    }

    post {
        always {
            // Cleanup Docker images
            sh 'docker rmi ${IMAGE_NAME} || true'
        }
    }
}
