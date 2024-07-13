pipeline {
    agent any

    environment {
        VIRTUALBOX_VERSION = '6.1'
        PROMETHEUS_VERSION = '2.35.0'
        GRAFANA_VERSION = '8.3.5'
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
                sudo apt update
                sudo apt install -y virtualbox-${VIRTUALBOX_VERSION}
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
                sh 'ansible-playbook -i inventories/hosts playbooks/create_vm.yml'
            }
        }

        stage('Testes e Validação') {
            steps {
                sh '''
                ssh usuario@endereco-da-vm 'echo "Hello from VM" > /tmp/teste.txt'
                '''
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
