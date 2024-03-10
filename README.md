# Aws_Microservices_Demo
cd12355 K8s project demo for scaling microservices on aws

# Coworking Space Service Extension
The Coworking Space Service is a set of APIs that enables users to request one-time tokens and administrators to authorize access to a coworking space. This service follows a microservice pattern and the APIs are split into distinct services that can be deployed and managed independently of one another.

For this project, you are a DevOps engineer who will be collaborating with a team that is building an API for business analysts. The API provides business analysts basic analytics data on user activity in the service. The application they provide you functions as expected locally and you are expected to help build a pipeline to deploy it in Kubernetes.

# Workspace Requirements for testing and building Coworking Space Service Extension
The workspace requirements mentioned below are to setup appropriate software for testing the provided flask based app endpoints locally and also to manage K8s cluster on AWS using aws cli v2. <br>
**Python 3.10:** Every python package used in building flask based app are pulled from latest sources. So, 3.10+ is recommended. <br>
**Docker 25.0.3:** Application build with flask are dockerized to build CI and CD pipelines keeping separation of concerns intact which is core part of Microservices pattern. <br>
**Kubectl client and server 1.29.2:** Kubectl client is essential to interact and deploy resources and services (communication within cluster and outside of cluster) on AWS EKS (Elastic Kubernetes Service). <br>
**helm 3.14.2:** Helm cli provides charts that are configurable for the software/apps which are deloyed on K8s. In this project it is used to deploy Postgresql on AWS EKS. Instead of creating app specific service and deployment yaml files for each app e.g. database app, helm chart provides flexible cli to manage app on K8s. <br>
**git and github:** Locally tested and created code is committed using git and  neceassry CI steps in AWS(Codebuild, Elastic Container Registry) can only takeplace with a repo on github. <br>


# Setup requirements to build Coworking Space Service Extension (Microservices) with CI and CD pipelines
**AWS Cli v2+:** Amazon AWS latest cli is recommended to build and deploy CI and CD pipelines on AWS Cloud. <br>
**AWS ECR(Elastic Container Registry):** ECR is necessary to keep dockerized flask app in AWS cloud. The artifacts in the ECR are then consumed by resources in EKS. <br>
**AWS Codebuild:** Codebuild is used to build CI pipeline. Codebuild configuration references repo from github, build the artifacts and docker container and pushes it to ECR. <br>
**AWS IAM(Identity and Access Management):** This is key piece of AWS service deployments. IAM manages policies to control resources running on microservices, essentially it handles AWS provided resource's authorization, authentication. <br>
**AWS EKS(Elastic Kubernetes Service):** EKS is cluster managing console which provides resources to hold nodes which actually run assigned workloads. EKS provides interface to build nodegroups and creating cluster using eks is first step before the actual EC2 machines are provisioned inside nodegroup to take up the workloads. <br>
**AWS Cloudwatch:** Monitor log output from pods which are running on cluster nodes. Also provides metrics to monitor workloads running on cluster and offers alarm services.

# Microservices with AWS deployment overview
The analytics app based on flask and postgresql microservices provides necessary components to build coworking space service. The coworking service consist to two types of pipelines: CI(continous integration) and CD(conitinous deployment/delivery) pipelines.

CI pipeline start from app code in the github. Webhook on pull request creation is configured in the aws codebuild. That means whenever a PR is created for Aws_Microservices_Demo repo, a build is trigger which will push docker container to ECR if all stages are successul. <br>
local_app->github_repo->codebuild->ecr <br>

CD pipeline starts from consuming the image from ECR in EKS. EKS allows to deploy the apps in production or tests before production using Microservices architecture. As describe already microcservices address separation of concerns principle and in the current implementation database service and application service are deployed separately with intra and inter communication takes place through defined end-points. This way every application can scale on its own terms with minimal depedency impact. Typical CD through EKS looks like this: <br>
app container in ECR->EKS->expose function endpoints in back-end->consume function endpoints in app front-end <br>

# Coworking Space Service Extension deployments steps

The following directories are provided for building coworking space service which includes building of analytics app: <br>
**/analytics:** actual app in coworking space serivce which exposes neccessary endpoints to access business logic. <br>
**/db:** Sql scripts to ingest or seed data into the created database with the specified schema <br>
**/deployments:** Contains services and deployments scripts for resources in the AWS cloud (EKS). The scripts are deployed using kubectl. The cloud resources such as EC2 machines which are provisioned inside cluster and neccassary communication services such as API access through defined ports that is required to build coworking space service is created using these scripts. <br>
**/:** Root of the project contains buildspec.yaml that triggers build on PR creation. Root also has dockerfile that dockerize the analytics app in analytics directory. <br>

Please note that steps describe below assumes that the provided code and structure to build coworking space as described above is already in the github. Now the steps to build coworking service are as follows: <br>

1. Pull the provided repo to build coworking service locally using git. <br>
2. Before building docker image as specified in the root directory 






