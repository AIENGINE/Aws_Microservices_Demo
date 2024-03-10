# Aws_Microservices_Demo
cd12355 K8s project demo for scaling microservices on aws

# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

# Workspace Requirements
The workspace requirements mentioned below are to setup appropriate software for testing provided flask app endpoints locally and also to manage K8s cluster on AWS using aws cli v2. <br>
**Python 3.10:** Every python package used in building flask based app are pulled from latest sources. So, 3.10+ is recommended. <br>
**Docker 25.0.3:** Application build with flask are dockerized to build CI and CD pipelines keeping separation of concerns intact which is core part of Microservices pattern. <br>
**Kubectl client and server 1.29.2:** Kubectl client is essential to interact and deploy resources and services (communication within cluster and outside of cluster) on AWS EKS (Elastic Kubernetes Service). <br>
**helm 3.14.2:** Helm cli provides charts that are configurable for the software/apps which are deloyed on K8s. In this project it is used to deploy Postgresql on AWS EKS. Instead of creating app specific service and deployment yaml files for each app e.g. database app, helm chart provides flexible cli to manage app on K8s. <br>
**git and github:** Locally tested and created code is committed using git and  neceassry CI steps in AWS(Codebuild, Elastic Container Registry) can only takeplace with a repo on github. <br>


# Setup requirements of Microservices with CI and CD pipelines
**AWS Cli v2+:** Amazon AWS latest cli is recommended to build and deploy CI and CD pipelines on AWS Cloud. <br>
**AWS ECR(Elastic Container Registry):** ECR is necessary to keep dockerized flask app in AWS cloud. The artifacts in the ECR are then consumed by resources in EKS. <br>
**AWS Codebuild:** Codebuild is used to build CI pipeline. Codebuild configuration references repo from github, build the artifacts and docker container and pushes it to ECR. <br>
**AWS IAM(Identity and Access Management):** This is key piece of AWS service deployments. IAM manages policies to control resources running on microservices, essentially it handles AWS provided resource's authorization, authentication. <br>
**AWS EKS(Elastic Kubernetes Service):** EKS is cluster managing console which provides resources to hold nodes which actually run assigned workloads. EKS provides interface to build nodegroups and creating cluster using eks is first step before the actual EC2 machines are provisioned inside nodegroup to take up the workloads. <br>
**AWS Cloudwatch:**



# Microservices with AWS deployment overview
