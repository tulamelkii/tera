cloud_id               = "b1gblbp7v441epoftcdg"
zone                   = "ru-central1-a"
bucket                 = "prodk8s"
max_size               = "4000"
default_storage_class  = "STANDARD"
name_vpc               = "subk8qw"
vpc_subnet             = ["192.168.2.0/28"]
ansible_user           = "debian"
ssh_path               = "/home/localadm/.ssh/id_ed25519.pub"
sec_group_name         = "allow-port"
cidr_block_all         = ["0.0.0.0/0"]
protocol_sec_group     = "tcp"

control_group_name     = "control"
resource_memory_c      = "2"
resource_cores_c       = "2"
user_name_ssh          = "localadm"
famili_images_c        = "debian-12"
size_boot_disk         = "20"
scale_size_c           = "1"
max_unavailable        = "1"
max_expansion          = "0"

worker_group_name      = "worker"
resource_memory_w      = "2"
resource_cores_w       = "2"
famili_images_w        = "debian-12"
size_boot_disk_w       = "20"
scale_size_w           = "2"
max_unavailable_w      = "1"
max_expansion_w        = "0"


#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
