pipeline {

agent any

environment {
    IMAGE_NAME = "kowshikpoojary8180/campusfit"
    IMAGE_TAG = "${BUILD_NUMBER}"
}

stages {

    stage('Checkout') {
        steps {
            echo "Pulling code from GitHub..."
            checkout scm
        }
    }

    stage('Build Docker Image') {
        steps {
            echo "Building Docker image..."

            sh '''
            docker build -t $IMAGE_NAME:$IMAGE_TAG .
            docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_NAME:latest
            '''
        }
    }

    stage('Push Docker Image') {
        steps {

            withCredentials([
                usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )
            ]) {

                sh '''
                echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                docker push $IMAGE_NAME:$IMAGE_TAG
                docker push $IMAGE_NAME:latest
                '''
            }
        }
    }

    stage('Deploy to Kubernetes') {
    steps {
        sh """
        kubectl set image deployment/campusfit \
        campusfit=${IMAGE_NAME}:${IMAGE_TAG} \
        -n campusfit

        kubectl rollout status deployment/campusfit \
        -n campusfit
        """
    }
}
    stage('Verify Deployment') {
    steps {
        sh '''
        echo "Checking Pods..."

        kubectl get pods -n campusfit

        echo "Checking Deployment..."

        kubectl rollout status deployment/campusfit -n campusfit

        echo "Verification Successful"
        '''
    }
}
}

post {

    success {
        echo "Deployment Successful"
    }

    failure {
        echo "Deployment Failed"
    }

    always {

        sh '''
        docker image prune -f
        '''
    }
}

}

