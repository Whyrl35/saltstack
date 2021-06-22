pipeline {
  agent {
    node {
      label 'agent1'
    }

  }
  stages {
    stage('Prepare') {
      steps {
        sh '''which salt-lint 2>&1 > /dev/null && FOUND=1 || FOUND=0

if [ $FOUND -eq 0 ]
then
  pip3 install --user salt-lint
fi'''
      }
    }

  }
}