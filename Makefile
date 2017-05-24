UNAME := $(shell uname)

default: dcon

dcon: docker_console

docker_console:
	docker exec -it me_app_1 /bin/bash

clean:
	git push origin --delete gh-pages && git branch -d gh-pages

publish:
	git subtree push --prefix app/dist origin gh-pages

.PHONY: publish clean docker_console dcon
