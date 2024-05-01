### 1.Preparing yandex-cloud 

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
yc iam service-account create --name <name_service_account>
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
yc config set service-account-key key.json       #  use save .../key.json
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
### 2.Create yandex provider terraform cluster

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
## 3.PREFERENCES FOR YANDEX-CLOUD              
###  3.1Create virtual network for k8s (vpc)
-create vpc zone ru-central1-a
```
resource "yandex_vpc_network" "network" {
  name        = "network"
  description = "virtual network cluster k8s for ru-central1-a"
      }
```
###  3.2.Create subnets for my network
- create subnet 
```
resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  description    = "subnet for cluster k8s"
  v4_cidr_blocks = ["192.168.49.0/28"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
}
```
### 3.3. Create service account for teraform, who started computer instance group
```
resource "yandex_iam_service_account" "tera" {
  name         = "tera"
  description  = "service account ks8"
}
```
### 3.4. Create member account tera for folder k8s.Add rules for folder
```
resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id  = "b1gahuuq85502ap2q4im"                                    # id folder k8s
  role       = "editor"                                                  #role for folder
  member     = "serviceAccount:${yandex_iam_service_account.tera.id}"    
  depends_on = [ yandex_iam_service_account.tera]                        # first must create service acc after add to folder
}
```
## 4. PREFERENCE INSTANCE 
### 4.1 Create istance group for control plane nodes
```
resource "yandex_compute_instance_group" "control" {
  name               = "control"                                             #name group
  folder_id          = "b1gahuuq85502ap2q4im"                                #folder id when created our group instance
  service_account_id = "${yandex_iam_service_account.tera.id}"               # service acc who member this group
  depends_on         = [yandex_resourcemanager_folder_iam_member.editor]     # first create folder and after group
```
### 4.2 Create template instance(characteristics) memory and cores
```
instance_template {
  resources {
  memory = 2
  cores  = 2
}
```
### 4.3 Create boot disk for  boot image (debian and size boot 15 gb)
```
boot_disk {
  mode = "READ_WRITE"                #option 
initialize_params {
  image_id = "fd87e3vsemiab8q1tl0h"  # Image Debian 11
  size     = 15                      # size
   }
 }


 yc compute image list --folder-id standard-images
