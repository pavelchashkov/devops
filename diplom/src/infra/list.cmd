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
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256...
ssh -i ~/.ssh/ya_id_ed25519 <IP3>
# SUDO
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256...

# ------------

docker build -t my-app .
docker image tag my-app pavelchashkov/netology-devops-app:0.1.0
docker image tag my-app pavelchashkov/netology-devops-app:latest
docker push pavelchashkov/netology-devops-app --all-tags

https://gitlab.com/pavelchashkov/netology-devops-app
https://hub.docker.com/repository/docker/pavelchashkov/netology-devops-app/tags