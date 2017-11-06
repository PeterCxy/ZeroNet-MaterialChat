.PHONY: debug debugDeploy prod

debug:
	rm -rf dist
	NODE_ENV=debug node_modules/.bin/webpack
	cp zeronet/* dist/

prod:
	rm -rf dist
	NODE_ENV=production node_modules/.bin/webpack
	cp zeronet/* dist/

debugDeploy: debug
	sh ./deploy.sh