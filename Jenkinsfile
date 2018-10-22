def testDrivers(container_image) {
    return {
        node {
            dockerInside image: container_image,
                links: [
                    "vnc-server"
                ],
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

germaniumPyExePipeline(
    runFlake8: false,
    binaries: [
        "Python 3": [
            dockerTag: "germanium_drivers_py3",
            versionManager: "-l ./version_values.yml",
            publishPypi: "sdist",
            postBuild: testDrivers("germanium_drivers_py3")
        ],
        "Python 2.7": [
            dockerTag: "germanium_drivers_py2",
            versionManager: "-l ./version_values.yml",
            publishPypi: "sdist",
            gbs: "/Dockerfile.py2",
            postBuild: testDrivers("germanium_drivers_py2")
        ]
    ],
    postBuild: {
        parallel([
            "Python 2.7": testDrivers("germanium_drivers_py2"),
            "Python 3": testDrivers("germanium_drivers_py3"),
        ])
    }
)

