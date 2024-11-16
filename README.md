# **Kafka Deployment**

There is a configuration for Kafka producer and consumer. The task at hand is to deploy them in Kubernetes (K8s).

## Local Testing

Before deploying in K8s, we will run the service locally to verify its working. Install Kafka in your local environment:  
After the Kafka broker is running, run your Kafka producer first with:

`go run main.go`

## Containerization
The dockerfiles for producer and consumers are built and pushed to dockerhub. 

   ```
docker build -t kafka-producer .
docker login 
docker tag kafka-producer:latest medhavisingh12/kafka:producer 
docker push medhavisingh12/kafka:producer
```

Similary the consumer is dockerized and pushed to dockerhub. 

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

```
terraform init
terraform validate
terraform plan
terraform apply
```


## Creating and Deploying Kafka producer and consumer using Helm chart

First a kafka broker is deployed to the cluster with bitnami helm charts with custom values which disables SASL

* `helm install kafka oci://registry-1.docker.io/bitnamicharts/kafka -f values.yaml`
  
To add topic

* `kubectl get pods`
* `kubectl exec -it kafka-controller-0 -- sh`
* `kafka-topics.sh --bootstrap-server localhost:9092 --create --topic message-log --partitions 1 --replication-factor 1`
* `kafka-topics.sh --bootstrap-server localhost:9092 --list`

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
