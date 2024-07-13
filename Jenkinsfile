pipeline {
    agent any

    environment {
        PROMETHEUS_VERSION = '2.35.0'
        GRAFANA_VERSION = '8.3.5'
        SONARQUBE_VERSION = 'latest'
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
                sh 'sudo apt update && sudo apt install -y virtualbox'
            }
        }

        stage('Criação da VM') {
            steps {
                dir('/home/viegas/devops/DevOps-InfraManager/ansible/playbooks') {
                    sh 'ansible-playbook create_vm_yml'
                }
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

        stage('Instalação do Docker') {
            steps {
                sh '''
                sudo apt-get update
                    sudo apt-get install -y ca-certificates curl
                    sudo install -m 0755 -d /etc/apt/keyrings
                    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                    sudo chmod a+r /etc/apt/keyrings/docker.asc
                    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                    sudo apt-get update
                    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
                '''
            }
        }

        stage('Validação da instalação do Docker') {
            steps {
                sh 'docker --version'
            }
        }

        stage('Instalação do SonarQube via Docker') {
            steps {
                sh 'sudo docker-compose -f /home/viegas/devops/DevOps-InfraManager/sonarqube/docker-compose.yml up -d'
            }
        }
    }

    post {
        always {
            echo 'Finalizando pipeline'
        }
    }
}
