pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/gabrielviegas/DevOps-InfraManager.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Vagrant Up') {
            steps {
                sh 'vagrant up'
            }
        }
        stage('Ansible Playbook') {
            steps {
                sh 'ansible-playbook -i hosts playbook.yml'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t sua-imagem .'
            }
        }
        stage('Docker Run') {
            steps {
                sh 'docker run -d sua-imagem'
            }
        }
    }
}
