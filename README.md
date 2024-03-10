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
**git and github:** Locally tested and created code is committed using git and  necessary CI steps in AWS(Codebuild, Elastic Container Registry) can only takeplace with a repo on github. <br>


# Setup requirements to build Coworking Space Service Extension (Microservices) with CI and CD pipelines

**AWS Cli v2+:** Amazon AWS latest cli is recommended to build and deploy CI and CD pipelines on AWS Cloud. <br>
**AWS ECR(Elastic Container Registry):** ECR is necessary to keep dockerized flask app in AWS cloud. The artifacts in the ECR are then consumed by resources in EKS. <br>
**AWS Codebuild:** Codebuild is used to build CI pipeline. It is managed build service. Codebuild configuration references repo from github, build the artifacts and docker container and pushes it to the ECR. <br>
**AWS IAM(Identity and Access Management):** IAM is a critical service for managing access to AWS resources. It allows you to define policies that control access to resources used by your microservices. Essentially, it handles authorization and authentication for AWS resources. <br>
**AWS EKS(Elastic Kubernetes Service):** EKS is cluster managing console which provides resources to hold nodes which actually run assigned workloads. EKS provides interface to build nodegroups and creating cluster using eks is first step before the actual EC2 machines are provisioned inside nodegroup to take up the workloads. <br>
**AWS Cloudwatch:** Monitor log output from pods which are running on cluster nodes. Also provides metrics to monitor workloads running on cluster and offers alarm services.

# Microservices with AWS deployment overview
The analytics app based on flask and postgresql microservices provides necessary components to build coworking space service. The coworking service consist to two types of pipelines: CI(continous integration) and CD(continuous deployment/delivery) pipelines.

CI pipeline start from app code in the github. Webhook on pull request creation is configured in the aws codebuild. That means whenever a PR is created for Aws_Microservices_Demo repo, a build is trigger which will push docker container to ECR if all stages are successul. <br>
    local_app->github_repo->codebuild->ecr

CD pipeline starts from consuming the image from ECR in EKS. EKS allows to deploy the apps in production or tests before production using Microservices architecture. As describe already microcservices address separation of concerns principle and in the current implementation database service and application service are deployed separately with intra and inter communication takes place through defined end-points. This way every application can scale on its own terms with minimal dependency impact. Typical CD through EKS looks like this: <br>
    app container in ECR->EKS->expose function endpoints in back-end->consume function endpoints in app front-end

# Coworking Space Service Extension deployments steps

The following directories are provided for building coworking space service which includes building of analytics app. At this point it is assumed that AWS account has been setup and necessary SW tools as mentioned above are installed. Furthermore, it is assumed that user has necessary know-how of various AWS services including IAM, setting up aws cli and kubectl client for managing k8s in the cloud, lastly basic understand of helm package manager: <br>
**/analytics:** actual app in coworking space service which exposes necessary endpoints to access business logic. <br>
**/db:** Sql scripts to ingest or seed data into the created database with the specified schema <br>
**/deployments:** Contains services and deployments scripts for resources in the AWS cloud (EKS). The scripts are deployed using kubectl. The cloud resources such as EC2 machines which are provisioned inside cluster and necessary communication services such as API access through defined ports that is required to build coworking space service is created using these scripts. <br>
**/:** Root of the project contains buildspec.yaml that triggers build on PR creation. Root also has dockerfile that dockerize the analytics app in analytics directory. <br>

Please note that steps described below assumes that the provided code and structure to build coworking space service as described above is already in the github. Now the steps to build coworking service are as follows: <br>

1. Pull the provided repo to build coworking service locally using git. <br>
2. Before building docker image from the dockerfile as specified in the root directory, five steps has to be performed: <br>
    a. Provision resources on EKS using aws cli, kubetcl cli, eks management console and IAM management console in the browser. This is done as follows:<br>
    Navigate to EKS to create cluster. Use Add Cluster from the management console. Here  cluster service role is required to be created before cluster is successfuly provisioned for nodegroups. So, for that navigate to IAM management console in the browser. In roles section create a role for cluster e.g. demo-eks-cluster-role which has AmazonEKSClusterPolicy. The steps can be followed as given in official aws docs. Please note that every provisioned resource in AWS is specified in the specific region e.g. here us-west-2 is assumed. <br>

    Once cluster is created. From the created cluster management console in EKS, create nodegroups to hold nodes for running workloads. From add node group create node group as before a necessary role is required to created here before machines are successfuly provisioned to take workloads. Navigate to IAM roles create a role as an example eks-node-role with the following policies: AmazonEC2ContainerRegistryReadOnly, AmazonEKS_CNI_Policy, AmazonEKSWorkerNodePolicy, AmazonEMRReadOnlyAccessPolicy_v2, AWSXrayWriteOnlyAccess, CloudWatchAgentServerPolicy. <br>
    
    Please follow official aws documentation to correctly follow every step. The steps to follow help are provided using official links along setting up the node group. Selection of appropriate machine specs are necessary in this step, as this will allow provisioning of workloads in a cost effective manner. Here, as an example t3a type instances were chosen, as the workloads pushed in the ECR build type are of x86_64. <br> 

    At this point local aws cli is configured correctly using aws configure with profile credentials. And below kubectl command returns the name of the cluster. <br>

        kubectl config current-context

    b. Setup private a container registery in ECR to hold containers pushed from local work space. This can be done from aws amazon elastic container registry console in the the browser.

    c. Create an aws codebuild project from Codebuild console in the browser. Few important considerations while setting-up the codebuild project: use of buildspec file, webhook on PR creation, setting up the variables used in the buildspec file and most importantly privilege option to build container so that build images can be pushed to specified ECR repo.
    
    d. Running the app locally. The steps are setting up the environment vars used in the app. <br>
        
        export DB_USERNAME=postgres <br>
        export DB_PASSWORD=${POSTGRES_PASSWORD} <br>
        export DB_HOST=127.0.0.1 <br>
        export DB_PORT=5433 \# later used to access port with port forwarding <br>
        export DB_NAME=postgres <br>
    Now launch the app in the same terminal, here it is assumed that launching app locally works while launching from analytics directory:

        python app.py

    
       
    e. Now in another terminal, navigate to deployments and apply resource specification files using kubectl in the following order. The describe deployments will setup volume and volume claim for Postgresql. <br>
        
        kubectl apply -f pv.yaml
        kubectl apply -f pvc.yaml    

    Check with the following command. The command should return postgresql-pvc as per pvc.yaml definition the storage class is gp2 and capacity is 1Gi:

        kubectl pvc get

    
    
    Now in this terminal issue the following commands using helm to setup Postgresql on K8s in EKS. Navigate to db directory. Note the parameters used for seting-up postgresql on eks. Some of the parameters mentioned in the shell script are resources that must be provisioned before running the script. Moreover, examine the variables used, as these variables are necessary to log into the postgresql running inside the pod. Follow the instruction output as populated in "helm_instruction_output.txt". <br>

        bash helm_postgresql.sh  

    Most important instructions to follow is to setup local port-forwarding as an example:

        kubectl port-forward --namespace default svc/demo-postgres-postgresql 5432:5432 &

    In the same terminal, while in db directory:

        export POSTGRES_PASSWORD=$(kubectl get secret --namespace default demo-postgres-postgresql -o jsonpath="{.data.password}" | base64 -d)

        export PGPASSWORD="$POSTGRES_PASSWORD"

        PGPASSWORD=$POSTGRES_PASSWORD psql --host localhost -U postgresuser -d postgres -p 5432 < <sql scripts one after the other>

3. Steps describe in step 2 will setup postregsql running on the eks cluster with specified data as described in sql files in db folder. In another terminal issue the following commands to test endpoint APIs locally in the analytics app. The examples here are provided as examples.

    Install httpie locally then issue
    http GET localhost:5153/readiness_check
    
    or install curl then issue

    curl -iX localhost:5153/readiness_check

4. Once the endpoints in the analytics app return http 200 code. This is the time to build docker image of the app and push that to the ECR. Note at this point analytics app has not been deployed in the cluster. Follow the instruction provided in ECR repo with "view push commands". <br> 
Find view push commands <br> ![ECR](/screenshots/docker_images_ecr_app.png "view push commands")
Copy the container URI provided, and paste this URI as image value under container section of the analytics-api.yaml. Now issue the following commands, while in root of the project:
    
    kubectl apply -f deployments/

    This will create resouces(k8s pods), services. At this point the output should look like this as an example: <br>
    ![kubectl cli](/screenshots/kubectl_get_svc_app.png "kubectl get svc")

5. Lastly, to check if coworking service is working as desired viewing the logs in aws cloudwatch is indispensible. <br>
![AWS CloudWatch](/screenshots/app_endpoints_logs_cloudwatch.png "app endpoint output as cloud logs")




