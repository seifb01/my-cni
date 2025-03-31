CLUSTER_NAME?=my-cni

.PHONY: cluster create init setup start up
cluster create init setup start up:
	kind create cluster --config kind/kind.yaml --name ${CLUSTER_NAME}

.PHONY: cni cp copy
cni cp copy:
	docker cp cni/10-my-cni.conf my-cni-control-plane:/etc/cni/net.d/10-my-cni.conf
	docker cp cni/my-cni my-cni-control-plane:/opt/cni/bin/my-cni
	docker exec my-cni-control-plane chmod +x /opt/cni/bin/my-cni

.PHONY: test
test:
	kubectl run nginx --image=nginx

.PHONY: enter
enter:
	docker exec -it my-cni-control-plane /bin/bash

.PHONY: delete destroy down stop
delete destroy down stop:
	kind delete cluster --name ${CLUSTER_NAME}

.PHONY: daemonset ds
daemonset ds:
	docker build --no-cache -t my-cni:1.0.0 .
	kind load docker-image my-cni:1.0.0 --name my-cni
	kubectl apply -f deploy/my-cni-daemonset.yaml
