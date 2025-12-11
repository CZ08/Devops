pipeline {
    agent any

    tools {
        maven 'M2_HOME'
    }

    environment {
        APP_ENV    = "DEV"
        IMAGE_NAME = "cz08/alpine"
        IMAGE_TAG  = "1.0.0"
    }

    options {
        timeout(time: 15, unit: 'MINUTES')
    }

    stages {

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                SCANNER_HOME = tool 'SonarScanner'
            }
            steps {
                withSonarQubeEnv('MySonarServer') {
                    sh """
                        ${SCANNER_HOME}/bin/sonar-scanner \
                          -Dsonar.projectKey=devops-demo \
                          -Dsonar.projectName=timesheet-devops \
                          -Dsonar.sources=src \
                          -Dsonar.java.binaries=target
                    """
                }
            }
        }

        stage('Build and push Docker Image') {
            steps {
                sh "docker build -t cz08/devops-app:latest ."
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
