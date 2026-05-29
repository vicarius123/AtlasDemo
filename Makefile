.PHONY: deploy smoke stop clean checksums

deploy:
	scripts/deploy-demo.sh

smoke:
	scripts/smoke-demo.sh

stop:
	scripts/stop-demo.sh

clean:
	scripts/stop-demo.sh -v

checksums:
	scripts/write-checksums.sh
