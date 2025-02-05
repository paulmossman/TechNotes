**<span style="font-size:3em;color:black">Ansible</span>**
***

A suite of IaC tools: provisioning, config management, and app deployment.

# Misc

## Check for K8s readiness / Register output
```
    - name: Wait for k8s Readiness (Node)
      kubernetes.core.k8s_info:
        kind: Node
        name: "<the Node name>"
        wait: true
        wait_timeout: 120
        wait_condition:
          reason: KubeletReady
          type: Ready
      register: node_readiness

    - name: Check k8s Readiness (Node)
      ansible.builtin.fail:
        msg: k8s Node {{ vm_name }} is not ready
      when: node_readiness.failed or
            node_readiness.resources is not defined or
            node_readiness.resources | length == 0
```

## Run a command against `localhost` / Debug value
playbook.yaml:
```
---
- hosts: 127.0.0.1
  connection: local
  tasks:
    - name: Run a command
      ansible.builtin.command: echo "{{ inventory_hostname }}"
      register: command_output
    - ansible.builtin.debug: msg="{{ command_output.stdout }}"
    - ansible.builtin.debug: msg="{{ command_output.stderr }}"

```
Run:
```
ansible-playbook playbook.yaml
```

# Ansible Galaxy

["Galaxy provides pre-packaged units of work known to Ansible as roles and collections."](https://galaxy.ansible.com/ui/)

[galaxy.xml file](https://docs.ansible.com/ansible/latest/dev_guide/collections_galaxy_meta.html)

[requirements.yml file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-and-collections-from-the-same-requirements-yml-file)