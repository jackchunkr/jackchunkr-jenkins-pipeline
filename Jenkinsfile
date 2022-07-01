//def label = "jnlp-${UUID.randomUUID().toString()}"
def label = "jenkins-slave"
podTemplate(
  label: label, 
  containers: [
		//container image는 docker search 명령 이용
    containerTemplate(
		  name: "docker", 
		  image: "docker:latest", 
		  ttyEnabled: true, 
		  command: "cat"
		),
		containerTemplate(
		  name: "kubectl", 
		  image: "lachlanevenson/k8s-kubectl", 
		  command: "cat", 
		  ttyEnabled: true)
	],
	//volume mount
	volumes: [
		hostPathVolume(hostPath: "/var/run/docker.sock", mountPath: "/var/run/docker.sock")
	]
) 

{
  node(label) {
    stage('CD') {
        container('kubectl') {
            sh 'kubectl get pod -A'
        }
    }
    stage('check docker') {
        container('docker') {
            sh 'docker ps'
        }
    }
  }
}