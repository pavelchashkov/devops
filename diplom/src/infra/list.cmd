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

# ------------

git submodule add git@gitlab.com:pavelchashkov/netology-devops-app.git
git commit -m "Added the submodule netology-devops-app"

# add git to packages
ansible-playbook -i inventory.yaml --key-file ~/.ssh/ya_id_ed25519 playbook_k8s_distr.yaml --tags "packages"

kubectl apply --server-side -f kube-prometheus/manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f kube-prometheus/manifests/

kubectl -n monitoring delete networkpolicies.networking.k8s.io --all # сетевые политики, которые запрещают доступ
kubectl --namespace monitoring patch svc grafana -p '{"spec": {"type": "NodePort"}}'

# netology-devops-app
docker build -t pavelchashkov/netology-devops-app:0.1.1 --platform=linux/amd64 .
docker image tag pavelchashkov/netology-devops-app:0.1.1 pavelchashkov/netology-devops-app:latest
docker push pavelchashkov/netology-devops-app --all-tags

kubectl create namespace netology
kubectl get pods -n netology
kubectl apply -f app-deployment.yml
kubectl get pods -n netology