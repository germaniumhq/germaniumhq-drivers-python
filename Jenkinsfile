
properties([
    parameters([
        string(name: 'LOCAL_PROXY',
               defaultValue: '172.17.0.1:3128',
               description: 'Squid proxy to use for fetching resources'),
        string(name: 'DRIVERS_SOURCES_URL',
               defaultValue: 'http://git-server:3000/germanium/germanium-drivers.git',
               description: 'Location for the drivers sources.'),
        booleanParam(name: 'RUN_FIREFOX_TESTS', defaultValue: true,
                description: 'Should the firefox tests run'),
        booleanParam(name: 'RUN_CHROME_TESTS', defaultValue: true,
                description: 'Should the chrome tests run')
    ])
])

RUN_FIREFOX_TESTS = Boolean.valueOf(RUN_FIREFOX_TESTS)
RUN_CHROME_TESTS = Boolean.valueOf(RUN_CHROME_TESTS)

stage("Build Germanium Drivers") {
    parallel 'Python 3.5': {
        node {
            deleteDir()

            checkout scm

            withCredentials([file(credentialsId: 'PYPIRC_RELEASE_FILE',
                                  variable: 'PYPIRC_RELEASE_FILE')]) {
                sh """
                    cp ${env.PYPIRC_RELEASE_FILE} ./jenkins/scripts/_pypirc_release
                    chmod 666 ./jenkins/scripts/_pypirc_release
                """
            }

            dockerBuild(file: './jenkins/Dockerfile.py3.build',
                build_args: [
                    "http_proxy=http://${LOCAL_PROXY}",
                    "https_proxy=http://${LOCAL_PROXY}",
                    "ftp_proxy=http://${LOCAL_PROXY}"
                ],
                tags: ['germanium_drivers_py3']
            )
        }
    }, 'Python 2.7': {
        node {
            deleteDir()

            checkout scm
            dockerBuild(file: './jenkins/Dockerfile.py2.build',
                build_args: [
                    "http_proxy=http://${LOCAL_PROXY}",
                    "https_proxy=http://${LOCAL_PROXY}",
                    "ftp_proxy=http://${LOCAL_PROXY}"
                ],
                tags: ['germanium_drivers_py2']
            )
        }
    }
}

def name = 'ge-drivers-' + getGuid()
//def name = 'ge-drivers-b64f4dbe-830d-4a2d-88ba-44b478b86cf0'

print "Building container with name: ${name}"

stage("Build and Test germanium-drivers") {
    parallel 'Python 3.5 Tests': {
        node {
            dockerRun image: 'germanium_drivers_py3',
                env: [
                    "DISPLAY=vnc:0",
                    "http_proxy=http://${LOCAL_PROXY}",
                    "https_proxy=http://${LOCAL_PROXY}",
                    "ftp_proxy=http://${LOCAL_PROXY}",
                    "SOURCES_URL=${DRIVERS_SOURCES_URL}",
                    "RUN_CHROME_TESTS=${RUN_CHROME_TESTS}",
                    "RUN_FIREFOX_TESTS=${RUN_FIREFOX_TESTS}",
                ],
                links: [
                    "nexus:nexus",
                    "vnc-server:vnc",
                    "git-server"
                ],
                name: name,
                privileged: true,
                command: "/scripts/test-drivers.sh"
        }
    }, 'Python 2.7 Tests': {
        node {
            dockerRun image: 'germanium_drivers_py2',
                env: [
                    "DISPLAY=vnc:0",
                    "http_proxy=http://${LOCAL_PROXY}",
                    "https_proxy=http://${LOCAL_PROXY}",
                    "ftp_proxy=http://${LOCAL_PROXY}",
                    "SOURCES_URL=${DRIVERS_SOURCES_URL}",
                    "RUN_CHROME_TESTS=${RUN_CHROME_TESTS}",
                    "RUN_FIREFOX_TESTS=${RUN_FIREFOX_TESTS}",
                ],
                links: [
                    "nexus:nexus",
                    "vnc-server:vnc",
                    "git-server"
                ],
                remove: true, // this is just used for testing
                privileged: true,
                command: "/scripts/test-drivers.sh"
        }

    }
}

stage("Commit Image") {
    node {
        sh """
            docker commit ${name} ${name}
        """
    }
}

stage("Install into local Nexus") {
    input message: 'Install into local Nexus?'

    node {
        dockerRun image: name,
            links: [
                "nexus:nexus"
            ],
            remove: true,
            command: "/scripts/release-nexus.sh"
    }
}

stage("Install into global PyPI") {
    input message: 'Install into global PyPI?'

    node {
        dockerRun image: name,
            remove: true,
            command: "/scripts/release.sh"
    }
}

