pipeline {
    agent any

    tools {
        terraform 'terraform' // Make sure this matches the configured tool in Jenkins
    }

    parameters {
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    triggers {
        pollSCM('* * * * *') // Runs every minute (for demo; consider reducing frequency)
    }
    environment {
        SLACKCHANNEL = 'D08B9AX3V6Y'
        SLACKCREDENTIALS = credentials('slack')
    }
 
    stages {
        stage('IAC Scan') {
            steps {
                script {
                    sh 'pip install pipenv'
                    sh 'pipenv install checkov'
                    def checkovStatus = sh(script: 'pipenv run checkov -d . -o junitxml --output-file checkov-results.xml', returnStatus: true)

                    junit allowEmptyResults: true, testResults: 'checkov-results.xml'

                    if (checkovStatus != 0) {
                        echo '⚠️ Checkov found issues. Proceeding anyway...'
                        // Uncomment the next line to fail the build on Checkov error
                        // error 'Checkov found critical issues.'
                    }
                }
            }
        }

        stage('Terraform Version') {
            steps {
                sh 'terraform version'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Format') {
            steps {
                sh 'terraform fmt --recursive'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Action') {
            steps {
                script {
                    sh "terraform ${params.action} -auto-approve"
                }
            }
        }
    }

    post {
        always {
            script {
                slackSend(
                    channel: env.SLACKCHANNEL,
                    color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger',
                    message: "📦 Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' completed with status: ${currentBuild.result}. View: ${env.BUILD_URL}"
                )
            }
        }

        failure {
            slackSend(
                channel: env.SLACKCHANNEL,
                color: 'danger',
                message: "❌ Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' failed. Check details: ${env.BUILD_URL}"
            )
        }

        success {
            slackSend(
                channel: env.SLACKCHANNEL,
                color: 'good',
                message: "✅ Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' succeeded. View: ${env.BUILD_URL}"
            )
        }
    }
}

