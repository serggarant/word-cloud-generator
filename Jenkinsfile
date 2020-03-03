pipeline {
    agent {
        dockerfile true
    }
    stages {
        stage('Download source') {
            steps {
                git url: 'https://github.com/L-Eugene/word-cloud-generator.git'
                
                sh 'ls -l'
                sh 'pwd'
            }
        }
        stage('Build application'){
            environment {
                GOPATH = "${WORKSPACE}"
                PATH = "$PATH:${WORKSPACE}/bin"
                XDG_CACHE_HOME='/tmp/.cache'
            }

            steps {
                sh 'echo $GOPATH'
                sh 'make'
            }
        }
    }
}
