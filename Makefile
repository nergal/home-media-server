prepare:
	for i in `cat SERVICES`; \
    do                       \
        mkdir -p config/$$i; \
    done

copy: prepare env
	cp config-transmission.json config/transmission/settings.json 2>/dev/null || :
	./build-rpxy-config.sh > config/rpxy/rpxy.toml 2>/dev/null || :

mdns: env
	chmod 664 media-mdns.service
	ln -s media-mdns.service /etc/systemd/system
	systemctl enable media-mdns

env:
	./build-env.sh > .env

install: prepare copy mdns env

start:
	systemctl start media-mdns
	for i in `cat SERVICES`;     \
    do                   \
        all="$$all $$i"; \
    done;                \
	docker-compose up -d $$all

stop:
	systemctl stop media-mdns
	docker-compose down

clean:
	systemctl disable media-mdns
	rm -f /etc/systemd/system/media-mdns.service
	rm -rf config
	rm -f .env

.PHONY: test install