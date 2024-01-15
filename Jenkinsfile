pipeline {
    agent any

    environment {
        PROD_USERNAME = 'ukamedodi'
        PROD_SERVER = '34.130.249.80'
        PROD_DIR = '/home/ukamedodi/myflix-movie-page'
        DOCKER_IMAGE_NAME = 'movie-page-deployment'
        DOCKER_CONTAINER_NAME = 'movie-page'
        DOCKER_CONTAINER_PORT = '5010'
        DOCKER_HOST_PORT = '5010'
    }

    stages {
        stage('Load Code to Workspace') {
            steps {
                checkout scm             
            }
        }

        stage('Deploy Repo to Prod. Server') {
            steps {
                script {
                    sh 'echo Packaging files ...'
                    sh 'tar -czf moviePage.tar.gz *'
                    sh "scp -o StrictHostKeyChecking=no moviePage.tar.gz ${PROD_USERNAME}@${PROD_SERVER}:${PROD_DIR}"
                    sh 'echo Files transferred'
                    sh "ssh -o StrictHostKeyChecking=no ${PROD_USERNAME}@${PROD_SERVER} 'pwd && mkdir myflix-movie-page || true && cd myflix-movie-page && tar -xzf moviePage.tar.gz && ls -l'"
                    
                }
            }
        }

        stage('Dockerize DB Application') {
            steps {
                script {
                    sh "ssh -o StrictHostKeyChecking=no ${PROD_USERNAME}@${PROD_SERVER} 'cd myflix-movie-page && docker build -t ${DOCKER_IMAGE_NAME} .'"
                    sh "echo Docker image for moviePage rebuilt. Preparing to redeploy container to web..."
                }
            }
        }

        stage('Redeploy Container') {
            steps {
                script {
                    sh "ssh -o StrictHostKeyChecking=no ${PROD_USERNAME}@${PROD_SERVER} 'cd myflix-movie-page && docker stop ${DOCKER_CONTAINER_NAME} || true'"
                    sh "ssh -o StrictHostKeyChecking=no ${PROD_USERNAME}@${PROD_SERVER} 'cd myflix-movie-page && docker rm ${DOCKER_CONTAINER_NAME} || true'"
                    sh "echo Container stopped and removed. Preparing to redeploy new version"

                    sh "ssh -o StrictHostKeyChecking=no ${PROD_USERNAME}@${PROD_SERVER} 'cd myflix-movie-page && docker run -d -p ${DOCKER_HOST_PORT}:${DOCKER_CONTAINER_PORT} --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}'"
                    sh "echo moviePage Microservice Deployed!"
                }
            }
        }
    }
}
