  pipeline {
    agent {
      node {
        label "master"
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
      
      stage('TF Unit Test') {
        steps {
          sh 'id'
          sh 'whoami'
          sh 'pwd'
          sh 'ls'
          sh 'terraform init'
          sh 'terraform validate'
          sh 'sleep 15' 
        }      
      }
      
      stage('TF Init&Plan') {
        steps {
           sh """
           ls
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
           cd test
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
           terraform apply 
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
