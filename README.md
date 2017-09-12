# SonarQube + Golang plugin

#### Description
By default [SonarQube][1] doesn't have golang plugin, therefore I have created a Dockerfile that will automatically add [golang plugin][2] (by uartois) during the build process of the docker image.

#### Build
``` bash
docker build --build-arg SERVICE=sonar --build-arg SONAR_VERSION=6.5 --build-arg SONARQUBE_HOME=/opt/sonarqube --build-arg SONARQUBE_USERNAME=sonar --build-arg SONARQUBE_PASSWORD=sonar --build-arg GOLANG_PLUGIN_VERSION=1.2.10 -t "sonar:latest" .
```

#### Run
```bash
docker run -p 9000:9000 sonar:latest
```

----------
  [1]: https://www.sonarqube.org/
  [2]: https://github.com/uartois/sonar-golang/releases

