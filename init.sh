#!/bin/bash

initiad config set client chain-id $CHAIN_ID
initiad config set client keyring-backend test
# the init output is very long, so we save it into a file
initiad init $MONIKER --chain-id $CHAIN_ID 2>&1 | cat - >> init_output.txt

wget https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json -O $HOME/.initia/config/genesis.json

### Set app.toml configs
#enable oracle
initiad config set app oracle.enabled "true"
initiad config set app oracle.oracle_address "oracle:8080"

#increase move module cache to 1 GiB
initiad config set app move.module-cache-capacity "1000"

# Set config.toml configs
# disable indexer
sed -i "s/^indexer *=.*/indexer = \"null\"/" $HOME/.initia/config/config.toml

