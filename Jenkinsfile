pipeline {
    agent any
    
    stages {
        stage('📥 Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('🐳 Build & Push Docker') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                        # Build Docker image
                        docker build -t zainabasim/devops-lab-app:latest .
                        
                        # Login to Docker Hub
                        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                        
                        # Push to Docker Hub
                        docker push zainabasim/devops-lab-app:latest
                    '''
                }
            }
        }

        stage('📊 Setup Monitoring Stack') {
    steps {
        sh '''
            # Create monitoring namespace
            kubectl create namespace monitoring 2>/dev/null || true
            
            echo "📦 Deploying Prometheus..."
            kubectl apply -f monitoring/prometheus.yaml -n monitoring
            
            echo "📊 Deploying Grafana..."
            kubectl apply -f monitoring/grafana.yaml -n monitoring
            
            # Wait for services to be ready
            sleep 20
            
            echo "✅ Monitoring stack deployed!"
            echo ""
            echo "📈 To access monitoring tools:"
            echo "1. Get minikube IP: minikube ip"
            echo "2. Get NodePorts: kubectl get svc -n monitoring"
        '''
    }
}


        
        stage('☸️ Deploy to Minikube') {
            steps {
                sh '''
                    # Update image in deployment
                    sed -i "s|image: .*|image: zainabasim/devops-lab-app:latest|g" deployment.yaml
                    
                    # Use kubectl directly (will use default config)
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml
                    kubectl apply -f pvc.yaml
                    
                    # Check what's deployed
                    kubectl get all
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline succeeded!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
