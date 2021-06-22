pipeline {
  agent {
    node {
      label 'agent1'
    }

  }
  stages {
    stage('Prepare') {
      steps {
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
        sh '''source ~/.profile

find . -type f -name "*.sls" ! -path "./formulas/*" | xargs salt-lint'''
      }
    }

  }
}