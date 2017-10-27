.PHONY: build deploy

build:
	rm -rf dist
	node_modules/.bin/webpack
	cp static/* dist/

deploy: build
	sh ./deploy.sh