pipeline {
    agent { node { label 'azure-vm' } }

    parameters {
      string(name: 'CLUSTER_NAME', defaultValue: '', description: 'Provide cluster name')
    }
    stages {
      stage('Create Cluster') {
        steps {
        script{
         withCredentials([azureServicePrincipal('610320c7-4515-4551-9505-0e3f4b7cd21f')]) {
           sh "az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} -t ${AZURE_TENANT_ID}" 
           sh "az acr login --name dvopsimages"
           docker.image('dvopsimages.azurecr.io/base/dvopssupport').inside("-v ${WORKSPACE}:/mnt -u -0:0") {
              sh "cd /mnt/cluster; set -x; az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} -t ${AZURE_TENANT_ID}; az account set --subscription a80b3931-1be9-4942-afb4-2cf9a987a136"
              sh "cd /mnt/cluster; terraform init '-backend-config=key=${CLUSTER_NAME}' -var clientid=${AZURE_CLIENT_ID} -var clustersecrect=${AZURE_CLIENT_SECRET} -var tenantid=${AZURE_TENANT_ID}"
              //sh 'cd /mnt/cluster; terraform init'
              sh 'cd /mnt/cluster; terraform -auto-approve'
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