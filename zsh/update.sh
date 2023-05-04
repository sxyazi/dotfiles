#!/bin/bash

for plugin in plugins/*; do
	if [ -d "$plugin" ]; then
		echo "Updating plugin: $plugin"
		cd "$plugin"
		git pull
		echo
		cd -
	fi
done
