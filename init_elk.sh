docker-compose up -d

docker-compose exec -T elasticsearch bin/elasticsearch-setup-passwords auto --batch > passwords.txt

pwd_kibana_system=$(cat passwords.txt | grep "PASSWORD kibana_system" | sed -E "s/PASSWORD kibana_system = ([a-zA-Z0-9]+)/\1/")
pwd_logstash_system=$(cat passwords.txt | grep "PASSWORD logstash_system" | sed -E "s/PASSWORD logstash_system = ([a-zA-Z0-9]+)/\1/")
pwd_elastic=$(cat passwords.txt | grep "PASSWORD elastic" | sed -E "s/PASSWORD elastic = ([a-zA-Z0-9]+)/\1/")

sed -i "s/xpack.monitoring.elasticsearch.username: elastic/xpack.monitoring.elasticsearch.username: logstash_system/" ./logstash/config/logstash.yml
sed -i "s/xpack.monitoring.elasticsearch.password: changeme/xpack.monitoring.elasticsearch.password: $pwd_logstash_system/" ./logstash/config/logstash.yml
sed -i "s/elasticsearch.username: elastic/elasticsearch.username: kibana_system/" ./kibana/config/kibana.yml
sed -i "s/elasticsearch.password: changeme/elasticsearch.password: $pwd_kibana_system/" kibana/config/kibana.yml
sed -i "s/changeme/$pwd_elastic/" ./logstash/pipeline/logstash.conf
sed -i "/ELASTIC_PASSWORD : changeme/d" ./docker-compose.yml
docker-compose restart kibana logstash
