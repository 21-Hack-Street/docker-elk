docker-compose up -d

pwd=$(docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch)

pwd_elk=$pwd[1]

sed -i "s/ELASTIC_PASSWORD : changeme//" ./docker-compose.yml