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
        sh '''if [ -e /home/jenkins/.local/bin/salt-lint ]
then
  echo "salt-lint is already installed"
else
  pip3 install --user salt-lint
fi'''
      }
    }

    stage('Validate') {
      steps {
        sh 'find . -type f -name "*.sls" ! -path "./formulas/*" | xargs salt-lint'
      }
    }

  }
}