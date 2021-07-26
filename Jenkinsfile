pipeline {
	agent none
	options {
		timestamps ()
	}
	stages {
		stage ('Creating docker container') {
			agent {
				dockerfile {
					filename 'Dockerfile'
					args '--network host'
				}
			}
			stages {
				stage('Checking code') { 
					steps {
						sh '''export GOPATH=$WORKSPACE
export PATH="$PATH:$(go env GOPATH)/bin"
go get github.com/tools/godep
go get github.com/smartystreets/goconvey
go get github.com/GeertJohan/go.rice/rice
go get github.com/serggarant/word-cloud-generator/wordyapi
go get github.com/gorilla/mux
make lint
make test
'''
					}
				}
				stage('Building  and uploading  to Nexus') { 
					steps {
					sh '''export GOPATH=$WORKSPACE
export PATH="$PATH:$(go env GOPATH)/bin"
rm -f artifacts/*
sed -i 's/1.DEVELOPMENT/1.$BUILD_NUMBER/g' ./rice-box.go
GOOS=linux GOARCH=amd64 go build -o ./artifacts/word-cloud-generator -v .
gzip ./artifacts/word-cloud-generator
mv ./artifacts/word-cloud-generator.gz ./artifacts/word-cloud-generator
ls ./artifacts/
'''
					nexusArtifactUploader artifacts: [[artifactId: 'word-cloud-generator', classifier: '', file: 'artifacts/word-cloud-generator', type: 'gz']], credentialsId: 'uploader', groupId: '1', nexusUrl: '192.168.2.4:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'word-cloud-builds', version: '1.$BUILD_NUMBER'
					}
				}
			}
		}
		stage('Creating one more docker container') {
			agent {
				dockerfile {
					dir 'alpine'
					filename 'Dockerfile'
					args '--network host'
				}
			}
			stages {
				stage ('Downloading and starting word-cloud-generator') {
					steps {
						sh '''curl -X GET -u downloader:downloader "http://192.168.2.4:8081/repository/word-cloud-builds/1/word-cloud-generator/1.$BUILD_NUMBER/word-cloud-generator-1.$BUILD_NUMBER.gz" -o /opt/wordcloud/word-cloud-generator.gz
gunzip -f /opt/wordcloud/word-cloud-generator.gz
rm -f artifacts/*
chmod +x /opt/wordcloud/word-cloud-generator
/opt/wordcloud/word-cloud-generator &
sleep 5
'''
					}
				}
				stage ('Running integration tests') {
					steps {
					sh '''res=`curl -s -H "Content-Type: application/json" -d '{"text":"test"}' http://127.0.0.1:8888/version | jq '. | length'`
if [ "1" != "$res" ]; then exit 99; fi
res=`curl -s -H "Content-Type: application/json" -d '{"text":"test"}' http://127.0.0.1:8888/api | jq '. | length'`
if [ "7" != "$res" ]; then exit 99; fi
'''
					}
				}
			}
		}
	}
}
