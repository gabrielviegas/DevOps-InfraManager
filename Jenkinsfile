pipeline {
    agent any

    environment {
        PROMETHEUS_VERSION = '2.35.0'
        GRAFANA_VERSION = '8.3.5'
        SUDO_PASSWORD = credentials('sudo-password')
        PATH = "/usr/local/bin:$PATH"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-token', url: 'https://github.com/gabrielviegas/DevOps-InfraManager.git'
            }
        }

        stage('Instalação do VirtualBox') {
            steps {
                sh '''
                echo ${SUDO_PASSWORD} | sudo -S apt update
                echo ${SUDO_PASSWORD} | sudo -S apt install -y virtualbox
                '''
            }
        }

        stage('Configuração do Prometheus') {
            steps {
                sh '''
                wget https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
                tar -xzf prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz
                cd prometheus-${PROMETHEUS_VERSION}.linux-amd64/
                ./prometheus --config.file=prometheus.yml &
                '''
            }
        }

        stage('Configuração do Grafana') {
            steps {
                sh '''
                wget https://dl.grafana.com/oss/release/grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
                tar -zxvf grafana-${GRAFANA_VERSION}.linux-amd64.tar.gz
                cd grafana-${GRAFANA_VERSION}/bin/
                ./grafana-server &
                sleep 10
                '''
            }
        }

        stage('Criação da VM') {
            steps {
                dir('/home/viegas/devops/DevOps-InfraManager/ansible/playbooks') {
                    sh 'ansible-playbook create_vm_yml'
                }
            }
        }

        stage('Finalização e Limpeza') {
            steps {
                sh '''
                pkill prometheus
                pkill grafana-server
                '''
            }
        }

        stage('Post-build Actions') {
            steps {
                echo 'Ações pós-build'
            }
        }
    }

    post {
        always {
            echo 'Finalizando pipeline'
        }
    }
}
