### Initia Dockerized
This repository is starting point to run a [Initia](https://initia.xyz/) Node/Validator+Oracle using docker compose

*Cosmovisor for automatic updates will be added soon* 

---
## Getting started
copy `.env.sample` to `.env` and fill it with your variables
Build or Pull images    

If you trust our images, make a pull:
```bash
docker compose pull
```
otherwise, build images:
```bash
docker compose build
```

run and exec into an ephemeral container:
```bash
docker compose run --rm --entrypoint /bin/bash node
```
inside the container run init script
```bash
/init.sh
```
if you want modify config files further edit the config manually
```bash
nano $HOME/.initia/config/config.toml
```

then create a new wallet (or import your wallet)

```bash
initiad keys add $WALLET_NAME
```
Now exit the container and run node service in background

```bash
docker compose up -d
```


## Restore snapshot or use state sync
first stop the running service
```bash
docker compose stop node
```
run an ephemeral container again 
```bash
docker compose run --rm --entrypoint /bin/bash node
```
inside this container run your snapshot/state sync commands, then exit and run service again
```bash
docker compose up -d
```

### Run arbitrary commands inside the node container
to run any commands using `initiad`, just exec into running node service
```bash
docker compose exec node bash
```
here you have access to `initiad` binary
