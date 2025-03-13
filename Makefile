.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

KUBECONFIG = $(shell pwd)/metal/kubeconfig.yaml
KUBE_CONFIG_PATH = $(KUBECONFIG)

default: metal system external smoke-test post-install clean

configure:
	./scripts/configure
	git status

metal:
	make -C metal

system:
	make -C system

external:
	make -C external

smoke-test:
	make -C test filter=Smoke

post-install:
	@./scripts/hacks

# TODO maybe there's a better way to manage backup with GitOps?
backup:
	./scripts/backup --action setup --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action setup --namespace=gitea --pvc=gitea-shared-storage
	./scripts/backup --action setup --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-0
	./scripts/backup --action setup --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-1
	./scripts/backup --action setup --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-2
	./scripts/backup --action setup --namespace=gitea --pvc=redis-data-gitea-redis-cluster-0
	./scripts/backup --action setup --namespace=gitea --pvc=redis-data-gitea-redis-cluster-1
	./scripts/backup --action setup --namespace=gitea --pvc=redis-data-gitea-redis-cluster-2
	./scripts/backup --action setup --namespace=kanidm --pvc=data-kanidm-0
	./scripts/backup --action setup --namespace=matrix --pvc=data-matrix-postgresql-0
	./scripts/backup --action setup --namespace=matrix --pvc=matrix-dendrite-jetstream-pvc
	./scripts/backup --action setup --namespace=matrix --pvc=matrix-dendrite-media-pvc
	./scripts/backup --action setup --namespace=matrix --pvc=matrix-dendrite-search-pvc
	./scripts/backup --action setup --namespace=paperless --pvc=paperless-data
	./scripts/backup --action setup --namespace=ollama --pvc=ollama-data
	./scripts/backup --action setup --namespace=zot --pvc=zot-data


restore:
	./scripts/backup --action restore --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action restore --namespace=gitea --pvc=gitea-shared-storage
	./scripts/backup --action restore --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-0
	./scripts/backup --action restore --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-1
	./scripts/backup --action restore --namespace=gitea --pvc=data-gitea-postgresql-ha-postgresql-2
	./scripts/backup --action restore --namespace=gitea --pvc=redis-data-gitea-redis-cluster-0
	./scripts/backup --action restore --namespace=gitea --pvc=redis-data-gitea-redis-cluster-1
	./scripts/backup --action restore --namespace=gitea --pvc=redis-data-gitea-redis-cluster-2
	./scripts/backup --action restore --namespace=kanidm --pvc=data-kanidm-0
	./scripts/backup --action restore --namespace=matrix --pvc=data-matrix-postgresql-0
	./scripts/backup --action restore --namespace=matrix --pvc=matrix-dendrite-jetstream-pvc
	./scripts/backup --action restore --namespace=matrix --pvc=matrix-dendrite-media-pvc
	./scripts/backup --action restore --namespace=matrix --pvc=matrix-dendrite-search-pvc
	./scripts/backup --action restore --namespace=paperless --pvc=paperless-data
	./scripts/backup --action restore --namespace=ollama --pvc=ollama-data
	./scripts/backup --action restore --namespace=zot --pvc=zot-data

test:
	make -C test

clean:
	docker compose --project-directory ./metal/roles/pxe_server/files down

docs:
	mkdocs serve

git-hooks:
	pre-commit install
