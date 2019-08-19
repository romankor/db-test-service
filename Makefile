TAG?=latest
PROJECT?=blue-forge-dev
IMAGE_NAME=gcr.io/$(PROJECT)/news-service
INSTANCE_CONNECTION_NAME?=$(PROJECT):us-central1:controller-db-dev
export IMAGE_NAME
export INSTANCE_CONNECTION_NAME

image_build:
	@echo Building $(IMAGE_NAME):$(TAG) 
	docker build -t $(IMAGE_NAME):$(TAG) .

image_push:
	@echo Pushing $(IMAGE_NAME):$(TAG)
	docker push $(IMAGE_NAME):$(TAG)

deploy:
	envsubst < ./k8s/deployment.yml | kubectl apply -f -

deploy-helm:
	helm install -n n ./helm-chart/ \
		--set sql.instanceName=$(INSTANCE_CONNECTION_NAME) \
		--set image.repository=${IMAGE_NAME} \
		--set image.tag=${TAG}

upgrade-helm:
	helm upgrade ./helm-chart/ n \
		--set sql.instanceName=$(INSTANCE_CONNECTION_NAME) \
		--set image.repository=${IMAGE_NAME} \
		--set image.tag=${TAG} \
		--debug --recreate-pods 

template-helm:
	helm template -n n ./helm-chart/ \
		--set sql.instanceName=$(INSTANCE_CONNECTION_NAME) \
		--set image.repository=${IMAGE_NAME} \
		--set image.tag=${TAG} --debug


create-service-account-secret:
	kubectl create secret generic cloudsql-instance-credentials \
		--from-file=./sql-admin.json \
		--namespace=default