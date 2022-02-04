# The below scripts are from a Linux Academy lab to install docker/kubernetes/flannel and join two nodes to the master.
#
# After completing the lab I was struck by how redundant entering the same commands manually on 3 different machines felt.
# This could definitely be automated with ansible via the shell module, or even by making use of all the many modules ansible has 
# Could likely be automated via a bash script via the ole "#!/bin/bash" since lines are executed sequentially
# I bet this is possible via PowerShell as well. 
#

# centos7, two nodes & one master setup

sudo su  

Enable the br_netfilter module for cluster communication.

modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
   
yum install -y yum-utils device-mapper-persistent-data lvm2

# install Docker.

    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce

#Configure the Docker Cgroup Driver to systemd, enable and start Docker
    
sed -i '/^ExecStart/ s/$/ --exec-opt native.cgroupdriver=systemd/' /usr/lib/systemd/system/docker.service 
systemctl daemon-reload
systemctl enable docker --now 
systemctl status docker
docker info | grep -i cgroup

#Add Kubernetes repo.

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
      https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


#Install Kubernetes.

    yum install -y kubelet kubeadm kubectl


#Enable Kubernetes. The kubelet service will not start until you run kubeadm init.

    systemctl enable kubelet


#*Note: Complete the following section on the MASTER ONLY!

Initialize the cluster using the IP range for Flannel.

    kubeadm init --pod-network-cidr=10.244.0.0/16


#Copy the kubeadm join command.

#Exit sudo and run the following:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config


#Deploy Flannel.

    kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

#Check the cluster state.

    kubectl get pods --all-namespaces
#*Note: Complete the following steps on the NODES ONLY!

#Run the join command that you copied earlier (this command needs to be run as sudo), then check your nodes from the master.

kubectl get nodes