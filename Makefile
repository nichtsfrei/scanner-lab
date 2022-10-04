ifndef GITHUB_REPOSITORY_OWNER
	GITHUB_REPOSITORY_OWNER := greenbone
endif

RSYNC := rsync -ltvrP --delete --exclude private/ --perms --chmod=Fugo+r,Fug+w,Dugo-s,Dugo+rx,Dug+w
RSYNC_BASE := rsync://feed.community.greenbone.net:
VERSION := 22.04

NASL_TARGET_DEFAULT := /var/lib/openvas/plugins
nasl_target := ${INSTALL_PREFIX}${NASL_TARGET_DEFAULT}

NOTUS_TARGET_DEFAULT := /var/lib/notus
notus_target := ${INSTALL_PREFIX}${NOTUS_TARGET_DEFAULT}

SC_TARGET_DEFAULT := /var/lib/gvm/data-objects/gvmd/22.04/scan-configs
sc_target := ${INSTALL_PREFIX}${SC_TARGET_DEFAULT}

all: deploy download-tests wait-for-openvas run-tests delete

check-feed-dirs:
	@ [ -d ${nasl_target} ] || (printf "\e[31m${nasl_target} missing\e[0m\n" && false)
	@ [ -d ${notus_target} ] || (printf "\e[31m${notus_target} missing\e[0m\n" && false)
	@ [ -d ${sc_target} ] || (printf "\e[31m${sc_target} missing\e[0m\n" && false)
	@ test -w ${nasl_target} || (printf "\e[31m${USER} cannot write into ${nasl_target}\e[0m\n" && false) 
	@ test -w ${notus_target} || (printf "\e[31m${USER} cannot write into ${notus_target}\e[0m\n" && false) 
	@ test -w ${sc_target} || (printf "\e[31m${USER} cannot write into ${sc_target}\e[0m\n" && false) 

update-local-feed: check-feed-dirs
	${RSYNC} ${RSYNC_BASE}/community/vulnerability-feed/${VERSION}/vt-data/nasl/ ${nasl_target}
	${RSYNC} ${RSYNC_BASE}/community/vulnerability-feed/${VERSION}/vt-data/notus/ ${notus_target}
	${RSYNC} ${RSYNC_BASE}/community/data-feed/${VERSION}/scan-configs/ ${sc_target}

deploy-openvas:
	kubectl apply -f openvas-deployment.yaml

deploy-victim:
	kubectl apply -f victim-deployment.yaml

deploy-slsw:
	kubectl apply -f slsw-deployment.yaml

deploy-slackware:
	kubectl apply -f slackware-deployment.yaml

deploy: deploy-openvas deploy-victim deploy-slackware deploy-slsw

delete-openvas:
	kubectl delete deployment/openvas

delete-victim:
	kubectl delete deployment/victim

delete-slsw:
	kubectl delete deployment/slsw

delete-slackware:
	kubectl delete deployment/slackware

delete: delete-openvas delete-victim delete-slackware delete-slsw

update-openvas:
	kubectl rollout restart deployment/openvas

update-victim:
	kubectl rollout restart deployment/victim

update-slsw:
	kubectl rollout restart deployment/slsw

update-slackware:
	kubectl rollout restart deployment/slackware

update: update-openvas update-victim update-slackware update-slsw

wait-for-openvas:
	sh wait-for-openvas.sh

prepare-release:
	cd feature-tests && make build-cmds
	mkdir -p release
	cp feature-tests/bin/* release/

build:
	$(MAKE) -C slsw build
	$(MAKE) -C slackware build

download-tests:
	rm -rf bin && mkdir bin
	cd bin && curl -qH "Accept: application/vnd.github+json" https://api.github.com/repos/greenbone/scanner-lab/releases | jq -r ".[0] .assets[] .browser_download_url"| xargs -I {} curl -LOJ "{}"
	chmod +x bin/run-feature-tests

run-tests:
	bin/run-feature-tests

push:
	$(MAKE) -C slsw push
	$(MAKE) -C slackware push
