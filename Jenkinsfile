pipeline {
  agent {
    node {
      label 'swarm-agent'
    }

  }
  stages {
    stage('Prepare') {
      steps {
        sh '''which python3 || (apt update && apt install -y python3 python3-pip)
'''
        sh 'which salt-lint || pip3 install salt-lint'
      }
    }

    stage('Validate') {
      steps {
        sh 'find . -type f -name "*.sls" ! -path "./formulas/*" | xargs salt-lint'
        catchError() {
          slackSend(message: 'Error during Validation \'salt-lint\' of the repository', color: 'danger', failOnError: true, tokenCredentialId: 'slack-token')
        }

      }
    }

    stage('Notification') {
      steps {
        slackSend(botUser: true, channel: '#développement', tokenCredentialId: 'slack-token', color: 'good', message: 'The build has succeeded')
      }
    }

  }
}