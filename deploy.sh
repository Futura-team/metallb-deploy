#!/bin/sh
deploy(){
	pool=$1
	kubectl apply -f namespace.yml
	sed -ri "s|\bPOOL\b|$pool|g" pool.yml
	kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
	kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/main/manifests/metallb.yaml
	kubectl apply -f pool.yml
	cleanup
}

cleanup(){
	sed -ri "s|\b$pool\b|POOL|g" pool.yml
}

if [ "$#" != 1 ]; then
	echo $0 "<network-pool-addr>"
	echo "example:" $0 "192.168.0.0/16"
	exit 2
fi

deploy
