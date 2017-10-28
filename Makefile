.PHONY: debug debugDeploy prod

debug:
	rm -rf dist
	NODE_ENV=debug node_modules/.bin/webpack

prod:
	rm -rf dist
	NODE_ENV=production node_modules/.bin/webpack

debugDeploy: debug
	sh ./deploy.sh