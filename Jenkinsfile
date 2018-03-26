
properties([
    parameters([
        string(name: 'IMAGE_NAME', defaultValue: '',
                description: 'Container image name. By default it is ge-drivers-<uid>'),
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

            dockerBuild(file: './Dockerfile.py3.build',
                tags: ['germanium_drivers_py3']
            )
        }
    }, 'Python 2.7': {
        node {
            deleteDir()
            checkout scm

            dockerBuild(file: './jenkins/Dockerfile.py2.build',
                tags: ['germanium_drivers_py2']
            )
        }
    }
}

// -------------------------------------------------------------------
// container name definition
// -------------------------------------------------------------------
def name
if (IMAGE_NAME) {
    name = 'ge-drivers-' + IMAGE_NAME
} else {
    name = 'ge-drivers-' + getGuid()
}

println "Building container with name: ${name}"

stage("Build and Test germanium-drivers") {
    parallel 'Python 3.5 Tests': {
        node {
            dockerRun image: 'germanium_drivers_py3',
                env: [
                    "DISPLAY=vnc:0",
                    "RUN_CHROME_TESTS=${RUN_CHROME_TESTS}",
                    "RUN_FIREFOX_TESTS=${RUN_FIREFOX_TESTS}",
                ],
                links: [
                    "nexus:nexus",
                    "vnc-server:vnc"
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
                    "RUN_CHROME_TESTS=${RUN_CHROME_TESTS}",
                    "RUN_FIREFOX_TESTS=${RUN_FIREFOX_TESTS}",
                ],
                links: [
                    "nexus:nexus",
                    "vnc-server:vnc"
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

