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
      }
    }

    stage('Notification') {
      steps {
        slackSend(botUser: true, channel: '#développement', tokenCredentialId: 'slack-token', color: 'good', attachments: '{ text: \'I find your lack of faith disturbing!\',     fallback: \'Hey, Vader seems to be mad at you.\',     color: \'#ff0000\' }')
      }
    }

  }
}