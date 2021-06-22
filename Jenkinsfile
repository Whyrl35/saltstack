pipeline {
  agent {
    node {
      label 'agent1'
    }

  }
  stages {
    stage('Prepare') {
      parallel {
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

        stage('PATH') {
          steps {
            sh 'echo $PATH'
          }
        }

      }
    }

    stage('Validate') {
      steps {
        sh 'find . -type f -name "*.sls" ! -path "./formulas/*" | xargs salt-lint'
      }
    }

  }
}