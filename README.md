# jackchunkr-jenkins-pipeline

jenkins plugin:
- Kubernetes :: Pipeline :: DevOps Steps
- Kubernetes CLI Plugin
- Kubernetes Client API Plugin
- Kubernetes Credentials Plugin
- Kubernetes plugin


jenkins serive: 
`````
spec:
  clusterIP: 172.20.30.225
  clusterIPs:
  - 172.20.30.225
  externalTrafficPolicy: Cluster
  ports:
  - name: http
    nodePort: 32704
    port: 80
    protocol: TCP
    targetPort: http
  - name: https
    nodePort: 31508
    port: 443
    protocol: TCP
    targetPort: https
  - name: slave
    nodePort: 30010
    port: 50000
    protocol: TCP
    targetPort: 50000
`````

jenkins Configure Clouds :
- Credentials : Secret text -> Secret(kubeconfig 등록) -> ID() -> Description()
- Jenkins URL : http://[URL]
- Jenkins tunnel : jenkins:50000

jenkins Configure Global Security:
- Agents : Fixed: 50000
 

참조: 
`````
참조사이트 : https://github.com/helm/charts/issues/1092
필히 참조 : https://github.com/jenkinsci/kubernetes-plugin
로드밸런시 포트 열기 : https://stackoverflow.com/questions/38486848/kubernetes-jenkins-plugin-slaves-always-offline

$ kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts:jenkins
`````

샘플 소스 코드 : 
`````
podTemplate(label: 'jenkins-slave-pod', 
  containers: [
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'maven',
      image: 'maven:3.6.2-jdk-8',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'node',
      image: 'node:8.16.2-alpine3.10',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
)

{
    node('jenkins-slave-pod') { 
        def registry = "192.168.194.129:5000"
        def registryCredential = "nexus3-docker-registry"

        // https://jenkins.io/doc/pipeline/steps/git/
        stage('Clone repository') {
            container('git') {
                // https://gitlab.com/gitlab-org/gitlab-foss/issues/38910
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/dockerizing']],
                    userRemoteConfigs: [
                        [url: 'http://192.168.194.132/root/stlapp.git', credentialsId: 'jacobbaek-privategitlab']
                    ],
                ])
            }
        }
        
        stage('build the source code via npm') {
            container('node') {
                sh 'cd frontend && npm install && npm run build:production'
            }
        }
        
        stage('build the source code via maven') {
            container('maven') {
                sh 'mvn package'
                sh 'bash build.sh'
            }
        }

        stage('Build docker image') {
            container('docker') {
                withDockerRegistry([ credentialsId: "$registryCredential", url: "http://$registry" ]) {
                    sh "docker build -t $registry/stlapp:1.0 -f ./Dockerfile ."
                }
            }
        }

        stage('Push docker image') {
            container('docker') {
                withDockerRegistry([ credentialsId: "$registryCredential", url: "http://$registry" ]) {
                    docker.image("$registry/stlapp:1.0").push()
                }
            }
        }
    }   
}
`````
