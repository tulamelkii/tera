## 1.Preparing yandex-cloud 

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
yc resource-manager <category_resources> add-access-binding <name_resources> --role <indeficator_role> 
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
yc iam service-account list <id acc>
yc resource-manager folder list <folder id>
```
yc iam key create --service-account-id <id account> --folder-name <name folder service account> --output key.json
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
- config set key for serrvice account
```
 yc config set service-account-key ...key.json
```
- export to env
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```
- create folder for yandex-cloud provaider .terraformrc and move [cp .terraformrc /home/user/]
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
## 2.Create yandex provider terraform cluster

- add yandex provider and 
```
terraform {
  required_providers {
      yandex = {
      source = "yandex-cloud/yandex"
               }
            } 
   required_version = ">= 0.13"
         }

```
- where we use zone
```

provider "yandex" {
   zone      = "ru-central1-a" #a,b,c,d
}
```
- terraform init
```
Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.108.1

Terraform has been successfully initialized!
```
## 3.Create virtual network for k8s (vpc)
-create vpc zone ru-central1-a
```
resource "yandex_vpc_network" "default" {
      name   = "vpc.k8s.network"
description  = "virtual network cluster k8s for ru-central1-a"
       }
```
## 4.Create subnets for my network
- create subnet cluster-subnet-a
```
resource "yandex_vpc_subnet" "cluster-subnet-a" {
         name  = "vpc.k8s.subnet"
   description = "subnet for cluster k8s"
v4_cidr_blocks = ["192.168.49.0/28"]
          zone = "ru-central1-a"
    network_id = "enpsm794i9o9rhvshgvi"
}
```
terraform apply :)
