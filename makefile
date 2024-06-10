# Загрузка переменных окружения из файла .env
ENV_FILE := local.env
include $(ENV_FILE)
export

DOCKER_IMAGE_NAME=$(DOCKER_LOGIN)/$(NAME_APP)

start:
	@echo Запуск golang проекта
	go run main.go

# Создание docker образа
docker-build:
	@echo "Создание docker образа $(DOCKER_IMAGE_NAME):"
	docker build -t $(DOCKER_IMAGE_NAME) .

# Просмотр списка образов и контейнеров
docker-ls:
	@echo "Список образов с именем $(NAME_APP):"
	docker images | grep $(NAME_APP)
	@echo "Список контейнеров с именем $(NAME_APP):"
	docker ps | grep $(NAME_APP)
	#docker inspect $(DOCKER_IMAGE_NAME)

docker-run:
	@echo "Имя образа $(DOCKER_IMAGE_NAME)"
	@echo "Имя контейнера --name $(DOCKER_IMAGE_NAME)"
	@echo "Контейнер удаляется при остановке --rm"
	#docker rm $(DOCKER_IMAGE_NAME)
	docker run -t --rm -p $(PORT):$(PORT) -e PORT=$(PORT) --name $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME)

# Остановка контейнера
docker-stop:
	docker stop $(DOCKER_IMAGE_NAME)

# Авторизоваться в репозитории docker
docker-login_repo:
	#docker login $(DOCKER_URL) -u $(DOCKER_LOGIN) -p $(DOCKER_PASSWORD)
	docker login -u $(DOCKER_LOGIN) -p $(DOCKER_PASSWORD)

# Выход из репозитория docker
docker-logout_repo:
	docker logout

docker-push:
#	@echo "Переименование образа docker tag <id_образа> <ваше_имя_пользователя_dockerhub>/<название_образа>
#	docker tag $(IMAGE_NAME):$(TAG_IMAGE) $(DOCKER_URL)/$(IMAGE_NAME):$(TAG_IMAGE)
# [docker.io/san35/go-ping]
	@echo "Отправка образа $(DOCKER_IMAGE_NAME) в docker хранилище $(DOCKER_URL)"
	docker push $(DOCKER_IMAGE_NAME)

open-docker-storage-brauser:
	@echo "Открытие $(DOCKER_URL) в браузере"
	open $(DOCKER_URL)

# Установка minikube, kubectl, helm, openlens
install-k8s:
	@echo "Установка kubectl - клиентская утилита для управления кластерами Kubernetes."
	brew install kubernetes-cli

	@echo "Установка Minikube - инструмент для запуска локального кластера Kubernetes."
	brew install minikube

	@echo "Установка helm"
	brew install helm

	@echo "Установка openlens - графический менеджер кластера Kubernetes"
	brew install --cask openlens

	@echo "версии"
	kubectl version
	minikube version
	helm version

# Запуск Minikube
start-k8s-minikube:
	minikube start --driver=docker

# Открытие dashboard Minikube в браузере
open-minikube-browser:
	open http://127.0.0.1:51042/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/

# Открыть документацию helm
helm-wiki:
	open https://helm.sh/docs/helm/

# Создание helm чарта - create
helm-create:
	helm create $(NAME_CHART)

# Первый заупуск helm  чарта
# helm install [NAME] [CHART] [flags]
# https://helm.sh/docs/helm/helm_install/
helm-install:
	helm install go-ping ./deploy-chart
	#helm install $(NAME_APP) $(NAME_CHART)

# обновление (установка) чарта
helm-upgrade:
	helm upgrade --install go-ping ./deploy-chart

# список деплоев
helm-list:
	helm list

# история ревизий helm - history
helm-history:
	helm history go-ping
	#helm history $(NAME_APP)

# откат на старую ревизию
# helm rollback {приложение} {номер ревизии}
helm-rollback:
	helm rollback $(NAME_APP) 2

# Переназаначение значений в файле values.yaml из командной строки
helm-set:


# Автоматический rollback при ошибке - atomic
helm-atomic:
	# пример деплоя с несуществующим образом и откаткой назад
