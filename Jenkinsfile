pipeline {
    agent any

    // Requires Maven to be configured in Jenkins under Global Tool Configuration with the name 'Maven3'
    tools {
        maven 'Maven3' 
    }

    environment {
        DOCKER_IMAGE = 'my-java-app'
        DOCKER_TAG = "v${env.BUILD_NUMBER}"
        CONTAINER_NAME = 'java-app-container'
    }

    stages {
            stage('Checkout') {
                steps {
                    checkout scm
                }
            }

            stage('Build & Test (Maven)') {
                steps {
                    // Use 'bat' instead of 'sh' for Windows
                    bat 'mvn clean package'
                }
            }

            stage('Docker Build') {
                steps {
                    script {
                        bat "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                        bat "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                    }
                }
            }

            stage('Docker Deploy') {
                steps {
                    script {
                        // Windows batch uses '|| exit 0' to ignore errors if the container doesn't exist yet
                        bat "docker stop ${CONTAINER_NAME} || exit 0"
                        bat "docker rm ${CONTAINER_NAME} || exit 0"
                        
                        bat "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    post {
        success {
            echo 'Pipeline executed successfully. Application is running on port 8080.'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}