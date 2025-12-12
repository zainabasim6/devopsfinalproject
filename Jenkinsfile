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
