# **Kafka Deployment**

There is a configuration for Kafka producer and consumer. The task at hand is to deploy them in Kubernetes (K8s).

## Local Testing

Before deploying in K8s, we will run the service locally to verify its working. Install Kafka in your local environment:  
After the Kafka broker is running, run your Kafka producer first with:

`go run main.go`

## Creation of EKS using terraform

The VPC and EKS blocks have been seperated into modules. Where a custom vpc is built with subnet,nat gateway, internet gateway and routes. The EKS cluster is created on this VPC where the worker nodes (node group) will be deployed inside private subnets. 

Custom IAM roles and policies are also created for the EKS cluster and for nodegroups.
eks_cluster_role: An IAM role for the EKS cluster with the AmazonEKSClusterPolicy.
eks_node_role: An IAM role for EKS worker nodes with the necessary policies:
AmazonEKSWorkerNodePolicy
AmazonEC2ContainerRegistryReadOnly
AmazonEKS_CNI_Policy

A security group was created for the EKS cluster and one for worker nodes with rules to:
Allow communication between nodes and the cluster API server.
Enable node-to-node communication.

Create using:

```terraform init
terraform validate
terraform plan
terraform apply


## Creating and Deploying Kafka producer and consumer using Helm chart

First a kafka broker is deployed to the cluster with bitnami helm charts with custom values which disables SASL

* `helm install kafka oci://registry-1.docker.io/bitnamicharts/kafka -f values.yaml`
  
To add topic

* `kubectl get pods`
* `kubectl exec -it kafka-controller-0 -- sh`
* `kafka-topics.sh --bootstrap-server localhost:9092 --create --topic message-log --partitions 1 --replication-factor 1`
* `kafka-topics.sh --bootstrap-server localhost:9092 --list`

## Containerization

We get the FQDN of our kafka-broker service and add it to the broker address in main.go in kafka-consumer as well as kafka-producer.The dockerfiles for producer and consumers are built and pushed to dockerhub.

   ```
docker build -t kafka-producer .
docker login 
docker tag kafka-producer:latest medhavisingh12/kafka:producer 
docker push medhavisingh12/kafka:producer
```

## Create and Deploy kafka consumer and producer pods

Similary the consumer is dockerized and pushed to dockerhub. 

Then two Helm charts for kafka producer and consumers are created. Where additonal kafka configs are added to the env in deployment.yaml which references the values in values.yaml:

```
kafka: 
brokerAddress: "kafka.default.svc.cluster.local:9092" #which is the FQDN of the broker we just deployed 
topic: "message-log"
groupID: "my-group"
```

Install the two helm charts
* `helm install kafka-producer .`
* `kubectl get pods`
* `kubectl logs <producer pod name> -f`
* `helm install kafka-consumer .`
* `kubectl get pods`
* `kubectl logs <consumer pod name> -f`


<img width="669" alt="Screenshot 2024-11-16 at 9 08 03 PM" src="https://github.com/user-attachments/assets/8e8847c0-95bd-420e-965e-ee0a608fd035">


## Install promethues

* `kubectl create namespace monitoring`
  
Add prometheus repo
* `helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`

Configure prometheus with custom values

* `helm install prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring`
* `kubectl get pods -n monitoring` #check all pods are up and running
* `kubectl get svc -n monitoring` 
* `kubectl port-forward svc/prometheus-stack-kube-prom-prometheus 9091:9090 -n monitoring` #open promethues UI

Check promethues UI

* `http://localhost:9091`

## Use and configure KEDA and kafka-lag-exporter for event driven Autoscaling

* ` helm install keda kedacore/keda --namespace=monitoring`

Scrape metrics from kafka broker

* `helm install my-kafka-lag-exporter kafka-lag-exporter/kafka-lag-exporter --namespace monitoring --set "clusters[0].name=monitoring"  --set "clusters[0].bootstrapBrokers=kafka.default.svc.cluster.local:9092"`

<img width="898" alt="Screenshot 2024-11-16 at 9 08 15 PM" src="https://github.com/user-attachments/assets/b1c9b636-e603-4881-b4ab-ff216bf0dd79">


* `kubectl port-forward svc/my-kafka-lag-exporter-service 8000:8000 -n monitoring` #verify metrics
* `http://localhost:8000`

<img width="1509" alt="kafka-metrics" src="https://github.com/user-attachments/assets/41f28887-86b3-4336-b7e6-5229e8d086ca">


Add kafka scrape configs to promethues with custom values

* `helm install prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f values.yaml`

Port forwarward prometheus service to verify if kafka-lag-exporter has been added to the target


<img width="1508" alt="kafka-lag" src="https://github.com/user-attachments/assets/55c4e614-b210-450d-94f2-4718f56d6aba">

run the custom query

* `max(kafka_consumergroup_group_max_lag{group="my-group"})`


<img width="1512" alt="custom-query" src="https://github.com/user-attachments/assets/7778d258-86e1-491f-8d1e-f45380685b9d">


Create scaledObjects to autoscale consumer pod based on lag and upgrade kafka-consumer helm chart 





 




