pipeline {
    agent any  // Runs on any available Jenkins agent
    
    // Environment variables for reuse
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-creds')
        DOCKER_IMAGE = 'zainabasim/devops-lab-app'
        KUBE_NAMESPACE = 'devops-namespace'
    }
    
    stages {
        // STAGE 1: Code Fetch Stage [6 Marks]
        stage('📥 Code Fetch Stage') {
            steps {
                echo 'Starting Code Fetch Stage...'
                
                // Clean workspace before checkout
                cleanWs()
                
                // Fetch code from GitHub
                git branch: 'main', 
                    url: 'https://github.com/zainabasim6/devopsfinalproject.git',
                    credentialsId: 'github-credentials'
                
                // List files to verify
                sh 'ls -la'
                
                echo '✅ Code successfully fetched from GitHub!'
            }
        }
        
        // STAGE 2: Docker Build & Push [10 Marks]
        stage('🐳 Docker Image Creation Stage') {
            steps {
                echo 'Starting Docker Build Stage...'
                
                script {
                    // Build Docker image with timestamp tag
                    def timestamp = sh(returnStdout: true, script: 'date +%Y%m%d%H%M%S').trim()
                    def imageTag = "${DOCKER_IMAGE}:${timestamp}"
                    
                    echo "Building Docker image: ${imageTag}"
                    
                    // Build the image
                    docker.build(imageTag)
                    
                    // Tag as latest
                    sh "docker tag ${imageTag} ${DOCKER_IMAGE}:latest"
                    
                    // Login to Docker Hub
                    withCredentials([usernamePassword(
                        credentialsId: 'docker-hub-creds',
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )]) {
                        sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    }
                    
                    // Push both tags
                    sh "docker push ${imageTag}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                    
                    echo "✅ Docker image pushed: ${imageTag}"
                }
            }
        }
        
        // STAGE 3: Kubernetes Deployment [17 Marks]
        stage('☸️ Kubernetes Deployment Stage') {
    steps {
        echo 'Starting Kubernetes Deployment...'
        script {
            sh '''
                # Export KUBECONFIG with correct path
                export KUBECONFIG=/var/lib/jenkins/.kube/config
                
                # Create namespace
                kubectl create namespace devops-namespace --dry-run=client -o yaml | kubectl apply -f -
                
                # Apply manifests
                kubectl apply -f deployment.yaml -n devops-namespace
                kubectl apply -f service.yaml -n devops-namespace
                kubectl apply -f pvc.yaml -n devops-namespace
                
                # Wait for deployment
                kubectl rollout status deployment/webapp-deployment -n devops-namespace
                
                # Show resources
                echo "=== Deployment Status ==="
                kubectl get all -n devops-namespace
            '''
        }
    }
}
        
        // STAGE 4: Monitoring Setup [17 Marks]
        stage('📊 Prometheus/Grafana Stage') {
            steps {
                echo 'Setting up Monitoring...'
                
                script {
                    // Create monitoring namespace
                    sh 'kubectl create namespace monitoring || true'
                    
                    // Install Prometheus using Helm
                    sh '''
                        helm upgrade --install prometheus prometheus-community/prometheus \
                            --namespace monitoring \
                            --set alertmanager.persistentVolume.storageClass="standard" \
                            --set server.persistentVolume.storageClass="standard"
                    '''
                    
                    // Install Grafana using Helm
                    sh '''
                        helm upgrade --install grafana grafana/grafana \
                            --namespace monitoring \
                            --set persistence.enabled=true \
                            --set persistence.storageClassName="standard" \
                            --set adminPassword="admin123"
                    '''
                    
                    // Expose services (for Minikube)
                    sh '''
                        kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-external --namespace monitoring
                        kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-external --namespace monitoring
                    '''
                    
                    // Get access URLs
                    sh '''
                        echo "=== Monitoring URLs ==="
                        minikube service prometheus-external --url -n monitoring
                        minikube service grafana-external --url -n monitoring
                    '''
                    
                    echo '✅ Monitoring stack deployed!'
                }
            }
        }
    }
    
    // POST-ACTIONS (run after all stages)
    post {
        success {
            echo '🎉 Pipeline completed successfully!'
            
            // Send notification (optional)
            emailext (
                subject: "SUCCESS: Pipeline ${env.JOB_NAME}",
                body: "Pipeline ${env.JOB_NAME} completed successfully!\nBuild: ${env.BUILD_URL}",
                to: 'your-email@example.com'
            )
        }
        failure {
            echo '❌ Pipeline failed!'
            
            // Get error logs
            sh '''
                echo "=== Last 50 lines of logs ==="
                kubectl logs deployment/webapp-deployment -n ${KUBE_NAMESPACE} --tail=50
            '''
        }
        always {
            // Cleanup Docker images to save space
            sh 'docker system prune -f'
            
            echo "Pipeline finished: ${currentBuild.result}"
        }
    }
}
