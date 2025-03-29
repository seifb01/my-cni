CLUSTER_NAME?=my-cni

.PHONY: cluster create init setup start up
cluster create init setup start up:
	kind create cluster --config kind.yaml --name ${CLUSTER_NAME}
	kubectl delete deploy -n kube-system coredns
	kubectl delete deploy -n local-path-storage local-path-provisioner

.PHONY: cni cp copy
cni cp copy:
	docker cp 10-my-cni.conf my-cni-control-plane:/etc/cni/net.d/10-my-cni.conf
	docker cp my-cni my-cni-control-plane:/opt/cni/bin/my-cni
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
	docker build -t my-cni:1.0.0 .
	kind load docker-image my-cni:1.0.0 --name my-cni
	kubectl apply -f my-cni-daemonset.yaml
