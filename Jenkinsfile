  pipeline {
    agent {
      node {
        label "7078"
      } 
    }
    environment {
      ARM_CLIENT_ID="${arm_client_key}"
      ARM_SUBSCRIPTION_ID="${arm_sub_id}"
      ARM_TENANT_ID="${arm_tenant_id}"
      ARM_CLIENT_PASSWORD="${arm_client_password}"
      
    }
    stages {
      stage('Fetch Latest_Code') {
        steps {
          git credentialsId: '17371c59-6b11-42c7-bb25-a37a9febb4db', url: 'https://github.com/ghanshyams92/tazt'
        }
      }
      stage('test') {
        steps {
          checkout([$class: 'GitSCM', branches: [[name: 'master']], userRemoteConfigs: [[url: '']]])
          script {
             sh "pipenv install"
             sh "pipenv run pip install bridgecrew"
             sh "pipenv run bridgecrew --directory .  --bc-api-key 1e54d25b-92c5-5498-a850-fbd5eea64509 --repo-id org/repo"
                }
            }
        }
      
      stage('TF Init & Unit Test') {
        steps {
          sh 'terraform init'
          sh 'terraform validate'
        }      
      }
      
      stage('TF Plan') {
        steps {
           sh """
           terraform plan
           """
        }      
      }
      stage('TerraTest Infra test and detroy') {
        steps {
           sh """
           export arm_client_key="${ARM_CLIENT_ID}"
           export arm_sub_id="${ARM_SUBSCRIPTION_ID}"
           export arm_tenant_id="${ARM_TENANT_ID}"
           export arm_client_password="${ARM_CLIENT_PASSWORD}"
           cd tests
           export PATH=$PATH:/usr/local/go/bin
           go test -tags azure . -v
           """
        }      
      }

      stage('Approval') {
        steps {
          script {
            def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
          }
        }
      }

      stage('Provision Infra in Target Cloud') {
        steps {
           sh """
           export arm_client_key="${ARM_CLIENT_ID}"
           export arm_sub_id="${ARM_SUBSCRIPTION_ID}"
           export arm_tenant_id="${ARM_TENANT_ID}"
           export arm_client_password="${ARM_CLIENT_PASSWORD}"
           terraform apply -auto-approve
           """
        }
      }
      stage('Show') {
        steps {
           sh """
           export arm_client_key="${ARM_CLIENT_ID}"
           export arm_sub_id="${ARM_SUBSCRIPTION_ID}"
           export arm_tenant_id="${ARM_TENANT_ID}"
           export arm_client_password="${ARM_CLIENT_PASSWORD}"
           terraform show
           """
        }
      }
    } 
  }
