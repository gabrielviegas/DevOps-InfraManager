pipeline {
    agent any

    environment {
        PROMETHEUS_VERSION = '2.35.0'
        GRAFANA_VERSION = '8.3.5'
        SONARQUBE_VERSION = 'latest'  // Adicione a versão do SonarQube que deseja utilizar
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
                echo ${SUDO_PASSWORD} | sudo -S apt install -y docker.io
                '''
            }
        }

        stage('Instalação do Docker Compose') {
            steps {
                sh '''
                echo ${SUDO_PASSWORD} | sudo -S curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
                echo ${SUDO_PASSWORD} | sudo -S chmod +x /usr/local/bin/docker-compose
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
                dir('/home/viegas/devops/DevOps-InfraManager/sonarqube') {
                    sh 'docker-compose -f docker-compose.yml up -d'
            }
        }
    }

    post {
        always {
            echo 'Finalizando pipeline'
        }
    }
}
