# jackchunkr-jenkins-pipeline

jenkins plugin:
- Kubernetes :: Pipeline :: DevOps Steps
- Kubernetes CLI Plugin
- Kubernetes Client API Plugin
- Kubernetes Continuous Deploy Plugin
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
 
