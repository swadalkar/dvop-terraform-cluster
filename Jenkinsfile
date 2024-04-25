pipeline {
    agent { node { label 'azure-vm' } }
    stages {
      stage('Create Cluster') {
        steps {
        script{
         withCredentials([azureServicePrincipal('admin')]) {
           sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID' 
           sh 'az acr login --name dvopsimages'
           docker.image('dvopsimages.azurecr.io/base/dvopssupport').inside("-v ${WORKSPACE}:/mnt") {
              sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID' 
              sh 'cd /mnt/cluster; terraform init -backend-config="key=t1"'
          }
         }
         }
        }
    }
}

  post {
        always { 
            script {
                sh "docker system prune --force --all --volumes"
            }
          
          cleanWs()
        }
    }
}