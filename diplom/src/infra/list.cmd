# ------------

yc components update
yc iam create-token
terraform init

terraform plan
terraform apply
terraform destroy

# ------------

ssh -i ~/.ssh/ya_id_ed25519 <IP1>
ssh -i ~/.ssh/ya_id_ed25519 <IP2>
ssh -i ~/.ssh/ya_id_ed25519 <IP3>

cp inventory.yaml ../ansible/inventory.yaml
ansible-playbook -i inventory.yaml --key-file ~/.ssh/ya_id_ed25519 playbook_k8s_distr.yaml

ssh -i ~/.ssh/ya_id_ed25519 <IP1>
# SUDO
kubeadm init
export KUBECONFIG=/etc/kubernetes/admin.conf

# USER
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# SUDO
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml

ssh -i ~/.ssh/ya_id_ed25519 <IP2>
# SUDO
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256:588a662b9095c5ae8837d254de6381499179c6240e3c0b49a67f4a76ed3385ae
ssh -i ~/.ssh/ya_id_ed25519 <IP3>
# SUDO
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256:588a662b9095c5ae8837d254de6381499179c6240e3c0b49a67f4a76ed3385ae