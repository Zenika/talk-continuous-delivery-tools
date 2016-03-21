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
 + poussma + jenkins + organization my-startup
 + creation repository server
 + mkdir my-app && cd my-app && cp ~/talk-continuous-delivery-app/* .
 + git init
 + git add .
 + git commit -m "first commit"
 + git remote add origin http://ci-tools/gogs/my-startup/server.git
 + git push -u origin master

## Configuration de nexus

URL: http://ci-tools.has-unlimited.space/nexus/
Account: admin / admin123 - deployment / deployment123

## Configuration de maven

 + settings.xml (login / password)
 + pom.xml

   <distributionManagement>
        <repository>
            <id>nexus</id>
            <url>http://ci-tools/nexus/content/repositories/releases</url>
        </repository>
        <snapshotRepository>
            <id>nexus</id>
            <name>Internal Snapshots</name>
            <url>http://ci-tools/nexus/content/repositories/snapshots</url>
        </snapshotRepository>
    </distributionManagement>


## Configuration de Jenkins

### build-core

 + Configure global security
 + Jenkins’ own user database
 + Disable signup
 + Logged-in users can do anything
 + Configure System
 + Maven Configuration / /usr/share/local/maven (including settings.xml)
 + New maven job 
 + git : http://ci-tools/gogs/my-startup/server.git
 + poll scm : * * * * *
 + Additional Behaviours: Polling ignores commits from certain users: jenkins (don't rebuild after release)
 + Goals and options: clean install
 + Post action: publish artifact

### deploy-test

 + This build is parameterized: List maven artifact versions
   + Name: SERVER
   + Repository Base URL: http://ci-tools/nexus/content/repositories/public
   + Group Id: my-startup
   + Artifact Id: server
   + Packaging: war
   + Versions filter: .*SNAPSHOT
   + Default: LATEST
 + Post action: Rundeck
   + Job Identifier
   + Job options: war_url=${SERVER_ARTIFACT_URL}
   + Wait for Rundeck job to finish
   + Include Rundeck job output
   + Tail Logging
   + Should fail the build

### it-test

 + Freestyle Job
 + echo "H4sICNN38FYAA21lbWUAjVO7DsQgDNv56gwMXmG4D+RLTqIN57zakywENNhxkq7PWD90ghToDm0ZCtjj/ANX5M3eCq7qWYQLQCtSO5axcazFAHd/M8oWOZ+nasRisfAllty3fZ66dtXghlSWHwpleMejUwQNobBubc1TB1AcaMMyQi0ehaFjIumY6AMQKYqpFI0ULbchNVJWA8QCuwHB07kOiC2Ii0GGhNGVfwSnKNZT1oSReXsYl2q8XujSBOMkxt/3nTHNOv6RmuAXEJs/bs4EAAA=" | base64 -d | gzip -d -c | xargs -0 echo && curl -I http://test:8080 | grep 200

### release-core

  + Maven job
  + git: http://ci-tools/gogs/my-startup/server.git
  + Additional Behaviours: Check out to specific local branch: master
  + Goals: release:prepare release:perform --batch-mode
 
###  deploy-prod

 + This build is parameterized: List maven artifact versions
   + Name: SERVER
   + Repository Base URL: http://ci-tools/nexus/content/repositories/public
   + Group Id: my-startup
   + Artifact Id: server
   + Packaging: war
   + Versions filter: [0-9]+.[0-9]+.[0-9]+
   + Default: LATEST
 + Post action: Rundeck
   + Job Identifier
   + Job options: war_url=${SERVER_ARTIFACT_URL}
   + Wait for Rundeck job to finish
   + Include Rundeck job output
   + Tail Logging
   + Should fail the build
