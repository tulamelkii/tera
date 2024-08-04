[control]
%{ for ip in control ~}
${ip} ansible_user=${ansible_user} ansible_private_key_file=${ansible_private_key_file}
%{ endfor ~}

[worker]
%{ for ip in worker ~}
${ip} ansible_user=${ansible_user} ansible_private_key_file=${ansible_private_key_file}
%{ endfor ~}

[all_hosts:children]
control
worker


