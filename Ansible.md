**<span style="font-size:3em;color:black">Ansible</span>**
***

A suite of IaC tools: provisioning, config management, and app deployment.

# Misc

## Check for K8s readiness
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

## Debug
```
fs
```

# Ansible Galaxy

["Galaxy provides pre-packaged units of work known to Ansible as roles and collections."](https://galaxy.ansible.com/ui/)

[galaxy.xml file](https://docs.ansible.com/ansible/latest/dev_guide/collections_galaxy_meta.html)

[requirements.yml file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-and-collections-from-the-same-requirements-yml-file)