#!/usr/bin/env bash
set -e

if [ ! -f $LOTUS_PATH/.init.params ]; then
	echo Initializing fetch params ...
	lotus fetch-params $SECTOR_SIZE
	touch $LOTUS_PATH/.init.params
	echo Done
fi

if [ ! -f $LOTUS_PATH/.init.genesis ]; then
	echo Initializing pre seal ...
	lotus-seed --sector-dir $GENESIS_PATH pre-seal --sector-size $SECTOR_SIZE --num-sectors 1
	echo Initializing genesis ...
	lotus-seed --sector-dir $GENESIS_PATH genesis new $LOTUS_PATH/localnet.json
	echo Initializing address ...
	ls -al $GENESIS_PATH
	ls -al $LOTUS_PATH
	lotus-seed --sector-dir $GENESIS_PATH genesis add-miner $LOTUS_PATH/localnet.json $GENESIS_PATH/pre-seal-t01000.json
	touch $LOTUS_PATH/.init.genesis
	echo Done
fi

ls -al $GENESIS_PATH
ls -al $LOTUS_PATH
echo Starting lotus deamon ...
exec lotus daemon --lotus-make-genesis=$LOTUS_PATH/devgen.car --genesis-template=$LOTUS_PATH/localnet.json --bootstrap=false --api=1234
