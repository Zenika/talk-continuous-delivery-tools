# talk-continuous-delivery-tools
# On stage

## Installation des pré-requis sur la vm

    sudo apt-get update
    sudo apt-get install -y git
    git clone https://github.com/ZenikaOuest/talk-continuous-delivery-app.git
    git clone https://github.com/ZenikaOuest/talk-continuous-delivery-tools.git
    cd talk-continuous-delivery-tools
    sudo ./bootstrap.sh
    exit

## Démarrage de la stack

    cd talk-continuous-delivery-tools && docker-compose up -d

## Configuration de gogs

 + creation user  / password
 + creation repository
 + mkdir my-app && cd my-app && cp ~/talk-continuous-delivery-app/* .
 + git init
 + git add .
 + git commit -m "first commit"
 + git remote add origin http://ci-tools.has-unlimited.space/gogs/mpousse/my-app.git
 + git push -u origin master

## Configuration de nexus

URL: http://ci-tools.has-unlimited.space/nexus/
Account: admin / admin123 - deployment / deployment123

## Configuration de maven

 + settings.xml
 + pom.xml

   <distributionManagement>
        <repository>
            <id>nexus</id>
            <url>http://ci-tools.has-unlimited.space/nexus/content/repositories/releases</url>
        </repository>
        <snapshotRepository>
            <id>nexus</id>
            <name>Internal Snapshots</name>
            <url>http://ci-tools.has-unlimited.space/nexus/content/repositories/snapshots</url>
        </snapshotRepository>
    </distributionManagement>


## Configuration de Jenkins

 + Configure global security
 + Jenkins’ own user database
 + Disable signup
 + Logged-in users can do anything
 + Configure System
 + Maven Configuration / Default settings provider / Filesystem / /usr/share/maven/conf/settings.xml
 + Maven installations / Add maven / Install automatically
 + New maven job 
 + git : http://ci-tools.has-unlimited.space/gogs/mpousse/my-app.git
 + poll scm : * * * * *
 + Goals and options: clean install
 + Enable release
 + Post action: publish artifact

