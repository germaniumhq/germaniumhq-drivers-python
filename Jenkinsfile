pipeline {
  agent any
  stages {
    stage('Build Germanium Drivers') {
      steps {
        node(label: 'docker-build') {
          git '$DRIVERS_SOURCES_URL'
          script {
            dockerBuild(file: './jenkins/drivers/Dockerfile.py3.build',
            build_args: [
              "http_proxy=http://${LOCAL_PROXY}",
              "https_proxy=http://${LOCAL_PROXY}",
              "ftp_proxy=http://${LOCAL_PROXY}"
            ],
            tags: ['germanium_drivers_test']
          )
        }
        
      }
      
    }
  }
  stage('Build and Test germanium-drivers') {
    steps {
      script {
        def name = 'ge-drivers-' + getGuid()
      }
      
      node(label: 'build-drivers') {
        script {
          dockerRun image: 'germanium_drivers_test',
          env: [
            "DISPLAY=vnc:0",
            "http_proxy=http://${LOCAL_PROXY}",
            "https_proxy=http://${LOCAL_PROXY}",
            "ftp_proxy=http://${LOCAL_PROXY}",
            "SOURCES_URL=${DRIVERS_SOURCES_URL}",
          ],
          links: [
            "nexus:nexus",
            "vnc-server:vnc"
          ],
          name: name,
          privileged: true,
          command: "/scripts/test-drivers.sh"
        }
        
      }
      
    }
  }
  stage('Commit Image') {
    steps {
      node(label: 'docker-commit') {
        script {
          sh """
          docker commit ${name} ${name}
          """
        }
        
      }
      
    }
  }
  stage('Install into local Nexus') {
    steps {
      input 'Install into local Nexus?'
      node(label: 'deploy-on-local-nexus') {
        script {
          dockerRun image: name,
          links: [
            "nexus:nexus"
          ],
          remove: true,
          command: "/scripts/release-nexus.sh"
        }
        
      }
      
    }
  }
}
environment {
  LOCAL_PROXY = '172.17.0.1:3128'
  DRIVERS_SOURCES_URL = 'git://172.17.0.1:11112/.git/'
}
}
