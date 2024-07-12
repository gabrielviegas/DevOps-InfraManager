pipeline {
    agent any

    environment {
        VIRTUALBOX_VERSION = '6.1'  // Versão do VirtualBox a ser instalada
        PROMETHEUS_VERSION = '2.35.0'  // Versão do Prometheus a ser instalada
        GRAFANA_VERSION = '8.3.5'  // Versão do Grafana a ser instalada
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/gabrielviegas/DevOps-InfraManager.git'
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
                script {
                    try {
                        sh 'ansible-playbook -i inventories/hosts playbooks/create_vm.yml'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Falha ao executar playbook do Ansible: ${e.message}"
                    }
                }
            }
        }

        stage('Testes e Validação') {
            steps {
                script {
                    try {
                        sh 'ssh usuario@endereco-da-vm \'echo "Hello from VM" > /tmp/teste.txt\''
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error "Falha ao executar teste na VM: ${e.message}"
                    }
                }
            }
        }

        stage('Finalização e Limpeza') {
            steps {
                script {
                    sh '''
                    pkill prometheus || true
                    pkill grafana-server || true
                    '''
                    echo 'Prometheus e Grafana parados com sucesso.'
                }
            }
        }

        stage('Post-build Actions') {
            steps {
                echo 'Executando ações pós-build'
                // Aqui você pode adicionar ações adicionais, como notificações ou arquivamento de artefatos
            }
        }
    }

    post {
        always {
            echo 'Finalizando pipeline'
        }
    }
}
