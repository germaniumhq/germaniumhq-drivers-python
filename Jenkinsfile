// -------------------------------------------------------------------
// properties
// -------------------------------------------------------------------
properties([
    safeParameters(this, [
        string(name: 'IMAGE_NAME', defaultValue: '',
                description: 'Container image name. By default it is ge-drivers-<uid>'),
        booleanParam(name: 'RUN_FIREFOX_TESTS', defaultValue: true,
                description: 'Should the firefox tests run'),
        booleanParam(name: 'RUN_CHROME_TESTS', defaultValue: true,
                description: 'Should the chrome tests run')
    ]),

    pipelineTriggers([
        upstream(
            threshold: 'SUCCESS',
            upstreamProjects: '/build-system/germaniumhq-python-build-system/master'
        )
    ])
])

safeParametersCheck(this)

stage("Build Germanium Drivers") {
    parallel 'Python 3.6': {
        node {
            deleteDir()
            checkout scm

            versionManager("-l ./version_values.yml")

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
if (params.IMAGE_NAME) {
    name = 'ge-drivers-' + params.IMAGE_NAME
} else {
    name = 'ge-drivers-' + getGuid()
}

println "Building container with name: ${name}"

stage("Test germanium-drivers") {
    parallel 'Python 3.6 Tests': {
        node {
            dockerRm containers: [name]
            dockerInside image: 'germanium_drivers_py3',
                links: [
                    "vnc-server"
                ],
                name: name,
                privileged: true,
                volumes: [
                    '/dev/shm:/dev/shm:rw'
                ],
                code: {
                    junitReports("/src/reports") {
                        // we export the DISPLAY, because we can't do variable references in the
                        // docker.image(..).inside(HERE) because they are not yet defined.
                        sh """
                            export DISPLAY=\$VNC_SERVER_PORT_6000_TCP_ADDR:0
                            cd /src
                            . bin/prepare_firefox.sh
                            behave --junit --no-color -t ~@ie -t ~@edge
                        """
                    }
                }
        }
    }, 'Python 2.7 Tests': {
        node {
            dockerRm containers: ["${name}2"]
            dockerInside image: 'germanium_drivers_py2',
                env: [
                    "DISPLAY=\$VNC_SERVER_PORT_6000_TCP_ADDR:0"
                ],
                links: [
                    "vnc-server"
                ],
                name: "${name}2",
                privileged: true,
                volumes: [
                    '/dev/shm:/dev/shm:rw'
                ],
                code: {
                    junitReports("/src/reports") {
                        // we export the DISPLAY, because we can't do variable references in the
                        // docker.image(..).inside(HERE) because they are not yet defined.
                        sh """
                            export DISPLAY=\$VNC_SERVER_PORT_6000_TCP_ADDR:0
                            cd /src
                            . bin/prepare_firefox.sh
                            behave --junit --no-color -t ~@ie -t ~@edge
                        """
                    }
                }
        }

    }
}

stage("Install into local Nexus") {
    node {
        dockerInside image: name,
            links: [
                'nexus:nexus'
            ],
            code: {
                withCredentials([file(credentialsId: 'PYPIRC_RELEASE_FILE',
                                      variable: 'PYPIRC_RELEASE_FILE')]) {
                    sh """
                        cp ${env.PYPIRC_RELEASE_FILE} /germanium/.pypirc
                        chmod 666 /germanium/.pypirc

                        cd /src
                        python setup.py sdist upload -r nexus
                    """
                }
            }
    }
}

stage("Install into global PyPI") {
    input message: 'Install into global PyPI?'

    node {
        dockerInside image: name,
            code: {
                sh "/src/bin/release.sh"
            }
    }
}

