pipeline {
    agent {
        dockerfile {
            additionalBuildArgs '-t imagess'
            customWorkspace '/tmp/'
        }
    }
    stages {
        stage('Build application'){
            environment {
                GOPATH = "${WORKSPACE}"
                PATH = "$PATH:${WORKSPACE}/bin"
                XDG_CACHE_HOME='/tmp/.cache'
            }

            steps {
                sh 'make'
            }
        }
    }
}
