.PHONY: build deploy

build:
	rm -rf dist
	node_modules/.bin/webpack

deploy: build
	sh ./deploy.sh