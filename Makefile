build:
	docker image build -t tmccormack14/bible-image:2023_11_14 .
	docker container run -d -t -p 83:8000 --name bible --env-file environemnt_variables.txt  tmccormack14/bible-image:2023_11_14
	docker exec bible bash mysql_install.sh ; docker exec bible bash mysql_config.sh
	docker exec bible bash client_install.sh

clean:
	docker container rm -f bible
	docker image rm tmccormack14/bible-image:2023_11_14