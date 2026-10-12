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
                // Pulls source code from the Git repository configured in the Jenkins job
                checkout scm
            }
        }

        stage('Build & Test (Maven)') {
            steps {
                // Compiles the code, runs tests, and packages the JAR
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Builds the Docker image using the Dockerfile
                    sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                    sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Docker Deploy') {
            steps {
                script {
                    // Stop and remove the existing container if it's already running
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    
                    // Run the newly built container
                    sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:latest"
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