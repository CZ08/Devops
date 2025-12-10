pipeline {
    agent any

    tools {
        maven 'M2_HOME'
    }

    environment {
        APP_ENV    = "DEV"
        IMAGE_NAME = "CZ08/Devops"
        IMAGE_TAG  = "1.0.0"
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {

        stage('Build Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('MySonarServer') {   // même nom que dans la config Jenkins
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                          -Dsonar.projectKey=devops-demo \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
            	sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }
    }

    post {
        always {
            echo "======always======"
        }
        success {
            echo "=====pipeline executed successfully ====="
        }
        failure {
            echo "======pipeline execution failed======"
        }
    }
}