.PHONY: deploy deploy-team smoke stop stop-team clean checksums

deploy:
	scripts/deploy-demo.sh

deploy-team:
	scripts/deploy-team.sh

smoke:
	scripts/smoke-demo.sh

stop:
	scripts/stop-demo.sh

stop-team:
	scripts/stop-team.sh

clean:
	scripts/stop-demo.sh -v

checksums:
	scripts/write-checksums.sh
