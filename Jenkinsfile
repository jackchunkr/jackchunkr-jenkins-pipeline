//def label = "jnlp-${UUID.randomUUID().toString()}"
def label = 'jenkins-slave'

def ECR_REGION = 'ap-southeast-1'
def ECR_IMG_NANE = 'pyhello'
def ECR_PATH = '962524913451.dkr.ecr.ap-southeast-1.amazonaws.com'
def ECR_AWS_CREDENTIAL_ID = "ecr:$ECR_REGION:aws-jackchun"

def GIT_URL = 'https://gitlab.aiops-mz.com/jackchun/jenkins-cicd.git'
def GIT_CREDENTIALS_ID = 'jenkinsfile-demo-cicd'

podTemplate(
  label: label, 
  containers: [
		//container image는 docker search 명령 이용
    //  containerTemplate(
		//   name: "git", 
		//   image: "alpine/git:latest", 
		//   ttyEnabled: true, 
		//   command: "cat"
		// ), 
    containerTemplate(
		  name: "python3", 
		  image: "python:3.6", 
		  ttyEnabled: true, 
		  command: "cat"
		),
		containerTemplate(
		  name: "docker", 
		  image: "docker:latest", 
		  command: "cat", 
		  ttyEnabled: true
    ),
    // containerTemplate(
    //   name: "aws-cli",
    //   image: "amazon/aws-cli:2.7.13",
    //   command: "cat",
    //   ttyEnabled: true
    // ), 
	],
	//volume mount
	volumes: [ 
    hostPathVolume(mountPath: '/usr/bin/docker', hostPath: '/usr/bin/docker'),
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),

		//hostPathVolume(hostPath: "/var/run/docker.sock", mountPath: "/var/run/docker.sock")
	]
) 

{
  node(label) {
    
    stage('clone source code') {
      git branch: 'main', credentialsId: GIT_CREDENTIALS_ID, url: GIT_URL
    }

    stage('app build') {
        container('python3') {
            //sh 'pwd'
            //sh 'ls -al'
            sh 'pip3 install flask' 
        }
    }
    
    stage ('image push to ECR') {
      container('docker') {
        app = docker.build("$ECR_PATH/$ECR_IMG_NANE", "--build-arg network=host .")
        docker.withRegistry("https://$ECR_PATH", "$ECR_AWS_CREDENTIAL_ID") {
            app.push("${env.BUILD_NUMBER}")
            app.push("latest")
        } 
      }
    }
  } 
} 
