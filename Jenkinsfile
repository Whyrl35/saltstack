pipeline {
  agent {
    node {
      label 'swarm-agent'
    }

  }
  stages {
    stage('Prepare') {
      steps {
        sh '''which python3 || (apt update && apt install -y python3 python3-pip) '''
        sh 'which salt-lint || pip3 install salt-lint'
      }
    }

    stage('Validate') {
      steps {
        sh 'find . -type f -name "*.sls" ! -path "./formulas/*" | xargs salt-lint'
      }
    }
  }

  post {
    success {
        slackSend channel: '#développement',
                  color: 'good',
                  message: "The pipeline ${currentBuild.fullDisplayName} completed successfully."
    }
    failure {
        slackSend channel: '#développement',
                  color: 'danger',
                  message: "The pipeline ${currentBuild.fullDisplayName} failed."
    }
    changed {
        slackSend channel: '#développement',
                  color: 'warning',
                  message: "There are changes in the pipeline ${currentBuild.fullDisplayName}."
    }
  }

}
