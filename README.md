# Kubernetes Demo
This project allows you to install Kubernetes cluster with sample application. 

## Infrastructure
You must have built infrastructure firstly in order to install the Kubernetes and then the application.  
The infrastructure is:
- three machines with CentOS 7 (2 CPUs or more and 2 GB or more of RAM)
  - master node (k8s-master)
  - two worker nodes (k8s-worker1, k8s-worker2)
- full network connectivity between all machines in the cluster
- user <code>admin</code> added with sudo privileges on all machines
- SSH access from one machine to others in the system (for user <code>admin</code>)
- ability to resolving hosts on all machines (DNS or adding entries into the <code>/etc/hosts</code> file)
#### Vagrant
For testing or demo purpose we will create cluster on virtual machines using Vagrant and VirtualBox.  
You can download Vagrant from https://www.vagrantup.com/   
Note: if you are Linux / MacOS user you may want to have changed <code>vagrant</code> directory to your own:
```bash
sudo chown -R $USER: ~/.vagrant.d
```
To get the cluster on just type:
```bash
cd infrastructure\vagrant
vagrant up
```
If later you want to destroy your cluster type:
```bash
vagrant destroy -f
```

## Kubernetes
To install Kubernetes follow these steps:
1. Login into Kubernetes master machine (k8s-master) via SSH as <code>admin</code> user
2. Install <code>Ansible</code>:
   ```bash
   sudo yum install -y epel-release
   sudo yum install -y ansible
   ```
3. Copy the application from the <code>app</code> directory into remote machine.  
4. Install Ansible requirements
   ```bash
   ansible-galaxy install -r ansible-requirements.yml
   ```
5. Run installer:
   ```bash
   ansible-playbook -i production.ini k8s-playbook.yml --ask-become-pass
   ```
6. Install Kubernetes dashboard:
   ```bash
   kubectl apply -f dashboard-adminuser.yml
   kubectl apply -f admin-role-binding.yml
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta6/aio/deploy/recommended.yaml
   ```
   Get and save token that will be used to login to UI later:
   ```bash
   kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
   ```
   Start dashboard UI:
   ```bash
   kubectl proxy
   ```
   Open dashboard UI:
   ```bash
   http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
   ```

## Application
To run Nginx type:
```bash
kubectl create deployment nginx --image=nginx
kubectl expose deploy nginx --port 80 --target-port 80 --type NodePort
```
Check status of resources:
```bash
kubectl get services
kubectl get deployments
kubectl get pods --all-namespaces
kubectl logs --namespace={namespace} {pod}
```
Remove Nginx:
```bash
kubectl delete service nginx
kubectl delete deployment nginx
```

## Issues:
1. After master node restart, the k8s is down:
   ```bash
   kubectl get nodes
   
   The connection to the server 192.168.33.101:6443 was refused - did you specify the right host or port?
   ```
