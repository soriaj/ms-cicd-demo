FROM jenkins/jenkins:jdk11

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml
ENV TZ=America/Los_Angeles

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt

COPY casc.yaml /var/jenkins_home/casc.yaml
COPY batinstall.sh batinstall.sh

USER root
ENV VERSION="3.8.6"

# Get Maven
RUN curl -o /tmp/apache-maven-${VERSION}-bin.tar.gz https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/${VERSION}/apache-maven-${VERSION}-bin.tar.gz \
  && tar xzf /tmp/apache-maven-${VERSION}-bin.tar.gz -C /opt/ \
  && ln -s /opt/apache-maven-${VERSION} /opt/maven \
  && ln -s /opt/maven/bin/mvn /usr/local/bin \
  && rm -f /tmp/apache-maven-${VERSION}-bin.tar.gz \
  && mkdir -p /.ssh

# Install bat cli
RUN bash batinstall.sh

COPY ["id_rsa_jenkins", "id_rsa_jenkins.pub", "/.ssh/"]
RUN chown -R jenkins:jenkins /.ssh/

ENV MAVEN_HOME /opt/maven

RUN chown -R jenkins:jenkins /opt/maven