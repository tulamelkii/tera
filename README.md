                                              ## Preperring 1

- download terraform 
- unzip terraform and move to /usr/bin/
- terraform -v
```
Terraform v1.7.4
on linux_amd64
```
- download and install yandex CLI
```
curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
- create service account for yandex-cloud
```
yc iam service-account create --name <имя_сервисного_аккаунта>
```
- add role for sa
```
yc resource-manager <category_resources> add-access-binding <name_resources> \
  --role <indeficator_role> \
  --subject serviceAccount:<identificator_service_account>
```
- list service account
```
yc iam service-account list
+----------------------+----------+
|          ID          |   NAME   |
+----------------------+----------+
| ajes10               | localadm |
+----------------------+----------+
```
- create iam key for service account
```
yc iam key create \
  --service-account-id <id account> \             # yc iam service-account list
  --folder-name <name folder service account> \   #   yc resource-manager folder list
  --output key.json
```
- create profile for yandex cli
```
yc config profile create localadm  
```
- create config
```
yc config set service-account-key key.json       # use save .../key.json
yc config set cloud-id <id_cloud>                #  yc resource-manager cloud list
yc config set folder-id <folder id>              #  yc resource-manager folder list
```
- export to env
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```
- create folder for yandex-cloud provaider .terraformrc
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
                                              ## 2 Create file terraform for cluster k8s

