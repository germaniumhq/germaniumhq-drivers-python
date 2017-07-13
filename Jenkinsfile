pipeline {
  agent any
  stages {
    stage('Build Germanium Drivers') {
      steps {
        node(label: 'master') {
          script {
            sh """
                pwd
                ls -la
                git clone $DRIVERS_SOURCES_URL
            """
          }
          
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
      
      node(label: 'master') {
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
      node(label: 'master') {
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
      node(label: 'master') {
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
parameters {
  string(name: 'LOCAL_PROXY', defaultValue: '172.17.0.1:3128', description: 'Proxy that will be used for downloading resources, so the build doesn\'t take eternities.')
  string(name: 'DRIVERS_SOURCES_URL', defaultValue: 'http://192.168.0.2:10080/germanium/germanium-drivers.git', description: 'germanium-drivers GIT sources')
}
}
