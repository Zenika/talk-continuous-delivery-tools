FROM jenkins
USER root
RUN  cd /tmp && \
     curl -O http://mirrors.ircam.fr/pub/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
     tar xzf apache-maven-*-bin.tar.gz -C /usr/local && \
     cd /usr/local && \
     ln -s apache-maven-* maven && \
     rm -rf /tmp/apache-maven-*

USER jenkins
COPY install_jenkins_plugins.sh /usr/local/bin/
COPY plugins.txt /usr/share/jenkins/ref/
RUN cat /usr/share/jenkins/ref/plugins.txt | xargs /usr/local/bin/install_jenkins_plugins.sh 
COPY settings.xml /usr/local/maven/conf/
