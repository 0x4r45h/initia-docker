#!/bin/bash

initiad config set client chain-id $CHAIN_ID
initiad config set client keyring-backend test
# the init output is very long, so we save it into a file
initiad init $MONIKER --chain-id $CHAIN_ID 2>&1 | cat - >> init_output.txt

wget https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json -O $HOME/.initia/config/genesis.json

# setting minimum-gas-prices = "0.15uinit,0.01uusdc"
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.15uinit,0.01uusdc\"|" $HOME/.initia/config/app.toml
#change listen address
sed -i "s#address = \"localhost:9090\"#address = \"0.0.0.0:9090\"#g" $HOME/.initia/config/app.toml

#enable oracle
sed -i '/^\[oracle\]/,/^\[/ s/^\(enabled\s*=\s*\)"false"/\1"true"/' $HOME/.initia/config/app.toml
sed -i '/^\[oracle\]/,/^\[/ s/^\(oracle_address\s*=\s*\)""/\1"oracle:8080"/' $HOME/.initia/config/app.toml
