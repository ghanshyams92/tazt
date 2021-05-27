pipeline {
agent {
        kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: test-odu
spec:
  securityContext:
    runAsUser: 10000
    runAsGroup: 10000
  containers:
  - name: jnlp
    image: 'jenkins/jnlp-slave:4.3-4-alpine'
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
  - name: yair
    image: us.icr.io/dc-tools/security/yair:1
    command:
    - cat
    tty: true
    imagePullPolicy: Always
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug-1534f90c9330d40486136b2997e7972a79a69baf
    imagePullPolicy: Always
    command:
    - cat
    tty: true   
    securityContext: # https://github.com/GoogleContainerTools/kaniko/issues/681
      runAsUser: 0
      runAsGroup: 0
  - name: openshift-cli
    image: openshift/origin-cli:v3.11.0
    command:
    - cat
    tty: true
    securityContext: # https://github.com/GoogleContainerTools/kaniko/issues/681
      runAsUser: 0
      runAsGroup: 0
  - name: checkov
    image: kennethreitz/pipenv:latest
    command:
    - cat
    tty: true
    securityContext: # https://github.com/GoogleContainerTools/kaniko/issues/681
      runAsUser: 0
      runAsGroup: 0
  - name: terraform-cli
    image: gsaini05/terraform-az-go:0.15
    command:
    - cat
    tty: true
    securityContext: # https://github.com/GoogleContainerTools/kaniko/issues/681
      runAsUser: 0
      runAsGroup: 0
  volumes:
  - name: regsecret
    projected:
      sources:
      - secret:
          name: regsecret
          items:
            - key: .dockerconfigjson
              path: config.json
  imagePullSecrets:
  - name: oduregsecret
  - name: regsecret
"""
        }
    }
  
    environment {
      ARM_CLIENT_ID="${arm_client_key}"
      ARM_SUBSCRIPTION_ID="${arm_sub_id}"
      ARM_TENANT_ID="${arm_tenant_id}"
      ARM_CLIENT_PASSWORD="${arm_client_password}"
      
    }
    stages {
      /* stage('Checkov: Analyzing static codes for IaC') {
          steps {
            container('checkov') {
            checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'github', url: 'https://github.com/ghanshyams92/tazt.git']]])
            script {
              sh "pipenv install"
              sh "pipenv run pip install checkov"
              sh "pipenv run checkov --directory tests/ -o junitxml > result.xml || true"
              junit "result.xml"
              }
          }
      }      
     }*/
      stage('TF Init & Unit Test') {
        steps {
          container('terraform-cli') {
          withCredentials([azureServicePrincipal('credentials_id')]) {
          sh """ 
          sed -i '11 i subscription_id="${ARM_SUBSCRIPTION_ID}"' main.tf
          sed -i '12 i client_id="$AZURE_CLIENT_ID"' main.tf
          sed -i '13 i client_secret="$AZURE_CLIENT_SECRET"' main.tf
          sed -i '14 i tenant_id="$AZURE_TENANT_ID"' main.tf
          sleep 5
          terraform init
          terraform validate
          """
        }      
      }
      }
      }
      stage('TF Plan') {
        steps {
           container('terraform-cli') {
           sh """
           export PATH=$PATH:/usr/local/go/bin

           terraform plan
           """
        }      
      }
     }
      stage('Terratest: Deploy, Validate & Undeploy') {
        steps {
           container('terraform-cli') {
           withCredentials([azureServicePrincipal('credentials_id')]) {
           sh """

           az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID
           cd tests
           export PATH=$PATH:/usr/local/go/bin
           go test -tags azure . -v
           """
        }      
      } 
     }
      }
      stage('Approval: Confirm/Abort') {
        steps {
          script {
            def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
          }
        }
      }

      stage('Provision Infra in MS Azure Cloud') {
        steps {
          container('terraform-cli') {
           sh """
           terraform apply -auto-approve
           """
        }
      }
    }
      stage('Show: Provisioned Infra Details') {
        steps {
          container('terraform-cli') {
           sh """
           terraform show
           """
        }
      }
    } 
  }
}
