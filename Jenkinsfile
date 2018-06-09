
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
    parallel 'Python 3.6': {
        node {
            sh """
                ls -la
                pwd
            """
            cleanDir()
            sh """
                ls -la
                pwd
            """
            checkout scm
            sh """
                ls -la
                pwd
                cat ./germaniumdrivers/install_driver.py
            """

            versionManager("-l ./version_values.yml")

            withCredentials([file(credentialsId: 'PYPIRC_RELEASE_FILE',
                                  variable: 'PYPIRC_RELEASE_FILE')]) {
                sh """
                    cp ${env.PYPIRC_RELEASE_FILE} ./jenkins/scripts/_pypirc_release
                    chmod 666 ./jenkins/scripts/_pypirc_release
                """
            }

            docker.build('germanium_drivers_py3',
                         '-f Dockerfile .')
        }
    }, 'Python 2.7': {
        node {
            deleteDir()
            checkout scm

            versionManager("-l ./version_values.yml")

            docker.build('germanium_drivers_py2',
                         '-f Dockerfile.py2 .')
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

stage("Test germanium-drivers") {
    parallel 'Python 3.6 Tests': {
        node {
            dockerRm containers: [name]
            dockerInside image: 'germanium_drivers_py3',
                env: [
                    "DISPLAY=vnc:0"
                ],
                links: [
                    "vnc-server:vnc"
                ],
                name: name,
                privileged: true,
                code: {
                    try {
                        sh """
                            cd /src
                            . bin/prepare_firefox.sh
                            behave --junit --no-color -t ~@ie -t ~@edge
                            python setup.py install
                            ls -ltr
                        """
                    } finally {
                        junit "/src/reports/*.xml"
                    }
                }
        }
    }, 'Python 2.7 Tests': {
        node {
            dockerRm containers: ["${name}2"]
            dockerInside image: 'germanium_drivers_py2',
                env: [
                    "DISPLAY=vnc:0"
                ],
                links: [
                    "vnc-server:vnc"
                ],
                name: "${name}2",
                privileged: true,
                code: {
                    try {
                        sh """
                            cd /src
                            . bin/prepare_firefox.sh
                            behave --junit --no-color -t ~@ie -t ~@edge
                            ls -ltr
                        """
                    } finally {
                        junit "/src/reports/*.xml"
                    }
                }
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
        dockerInside image: name,
            links: [
                'nexus:nexus'
            ],
            code: {
                sh "/scripts/release-nexus.sh"
            }
    }
}

stage("Install into global PyPI") {
    input message: 'Install into global PyPI?'

    node {
        dockerInside image: name,
            code: {
                sh "/scripts/release.sh"
            }
    }
}

