docker-compose build
docker-compose up -d liferay-portal-node-1
# wait until it starts. You can also check docker-compose logs to validate that
docker-compose up -d liferay-portal-node-2
docker-compose up -d haproxy
