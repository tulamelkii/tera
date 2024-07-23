
[control]
%{ for ip in control ~}
${ip}
%{ endfor ~}

[worker]
%{ for ip in worker ~}
${ip}
%{ endfor ~}

[all_hosts:children]
control
worker


[all_hosts:vars]
ansible_user=debian
ansible_ssh_private_key_file=/home/localadm/.ssh/git.pub

