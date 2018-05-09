#!/usr/bin/env bash
cd $(dirname $0)
cd ../
# new version
mkdir -p $HOME/.cache/yarn
mkdir -p $HOME/.nuget

if ! $(docker network inspect db >/dev/null 2>&1)
then
	docker network create db
fi

docker-compose -f docker-compose.yml -f ci/compose-dev-db.yml -p dev up -d --build
docker-compose -p dev logs -f &
pid=$!

for i in `seq 1 600`; do
	# wait for containers to come up
	sleep 1
	# get a response from backend and frontend
	curl localhost:48010 >/dev/null 2>&1 && curl localhost:48001 >/dev/null 2>&1
	# exit if successful
	if [ $? -eq 0 ]; then
		kill $pid
		wait $pid
		echo "Docker container started"
		exit 0
	fi
done

# init script did not run
kill $pid
wait $pid
>&2 echo "Docker container did not start"
exit 1
