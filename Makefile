TIMESTAMP := $(shell date +%s)
start:
	docker-compose up -d
	make logs

stop:
	docker-compose down

restart:
	make stop
	make start

shell:
	docker-compose run --rm jekyll sh

deploy:
	docker compose run --rm jekyll jekyll build
	scp -r ./_site proxyweb:/var/www/edelprino.com-$(TIMESTAMP)
	ssh proxyweb "ln -sf /var/www/edelprino.com-$(TIMESTAMP) /var/www/edelprino.com"
	# ssh proxyweb "ls -t ~/edelprino.com-* | tail -n +6 | xargs rm --"

logs:
	docker-compose logs -f
