import jenkins.model.*
jenkins = Jenkins.instance

  pipeline {
    agent {
      node {
        label "master"
      } 
    }
    environment {
      arm_client_key="${ARM_CLIENT_ID}"
      arm_sub_id="${ARM_SUBSCRIPTION_ID}"
      arm_tenant_id="${ARM_TENANT_ID}"
      arm_client_password="${ARM_CLIENT_PASSWORD}"
      
    }
    stages {
      stage('Fetch Latest_Code') {
        steps {
          git credentialsId: '17371c59-6b11-42c7-bb25-a37a9febb4db', url: 'https://github.com/ghanshyams92/tazt'
        }
      }
      
      stage('TF Unit Test') {
        steps {
          sh 'terraform init'
          sh 'terraform validate'
        }      
      }
      
      stage('TF Init&Plan') {
        steps {
           sh """
           export arm_client_key="${ARM_CLIENT_ID}"
           export arm_sub_id="${ARM_SUBSCRIPTION_ID}"
           export arm_tenant_id="${ARM_TENANT_ID}"
           export arm_client_password="${ARM_CLIENT_PASSWORD}"
           terraform init
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
