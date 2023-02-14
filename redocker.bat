docker rm front-angular-to-net-core:1 --force
docker rmi front-angular-to-net-core:1
docker build -t front-angular-to-net-core:1 .
docker run --hostname front-angular-to-net-core --name front-angular-to-net-core -d -p 443:443 front-angular-to-net-core:1
