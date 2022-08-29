# Azure DevOps (Pipelines)

Prisma Cloud has an [Azure DevOps extension](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin/prisma-cloud-devops-security/use-the-prisma-cloud-extension-for-azure-devops.html) that covers scanning IaC templates, container images, and serverless functions.

This directory contains an example of a basic Azure DevOps pipeline that integrates container image scanning for vulnerabilities and compliance issues directly into Azure DevOps

This example only created a dockerfile and builds an image using that Dockerfile and scans the resultant image. The intent is to demonstrate how twistcli may fit into your Azure DevOps pipeline.

## Requirements
To use this Codefresh pipeline, you will need
* a functional Prisma Cloud Compute Console that is reachable from the Azure DevOps build environment
* credentials for a Compute user ([CI User](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/authentication/user_roles.html) or [Build and Deploy Security](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/authentication/prisma_cloud_user_roles.html) role with "Only Access Key" selected is recommended)

## Setup
1. Create a repo in Azure DevOps. You can have this repo created in any scm(Guthub, Gitlab etc). Add an empty file - azure-pipelines.yml.

    ![Screen Shot 2022-03-29 at 4 09 05 PM](https://user-images.githubusercontent.com/54907685/160721269-e92fb9fb-4cbb-4282-9d97-36955febbef3.png)
    
    
2. Open the pipeline and create the variables used by the pipeline (`PCC_USER`, `PCC_PASS`, and `PCC_CONSOLE_URL`).
You can do this either at the pipeline or project level.

    If you are using Prisma Cloud Compute Edition (self-hosted), `PCC_USER` and `PCC_PASS` will likely just be your normal username and password of the user with CI User role.
    `PCC_CONSOLE_URL` will be the address you use to access the Compute Console.

    If you are using Prisma Cloud Enterprise Edition (SaaS), `PCC_USER` and `PCC_PASS` will be your [access key and secret key](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/authentication/access_keys.html) pair created with the Build and Deploy Security role.
    `PCC_CONSOLE_URL` will be the address found at **Compute > Manage > System > Downloads** under the **Path to Console** heading.
    
    ![Screen Shot 2022-03-29 at 4 13 17 PM](https://user-images.githubusercontent.com/54907685/160721499-4df66228-564e-4e04-89a0-84a6ce65c267.png)

2. Add a command line task to create a docker file.

     ![Screen Shot 2022-03-29 at 4 17 01 PM](https://user-images.githubusercontent.com/54907685/160721789-ada1883f-edfe-4d6c-9cb6-e5087baca6aa.png)


3. Add a docker step to build the image using the docker file.

    ![Screen Shot 2022-03-29 at 4 17 44 PM](https://user-images.githubusercontent.com/54907685/160721831-d85c362a-0c20-4f60-877a-56f8e20ea951.png)


4. Add command line task to run twistcli commands.
   
    ![Screen Shot 2022-03-29 at 4 20 26 PM](https://user-images.githubusercontent.com/54907685/160722049-e11a2788-571c-4701-a72d-4f7678735fc9.png)

   
5. Save and run the pipeline

    ![Screen Shot 2022-03-29 at 4 25 17 PM](https://user-images.githubusercontent.com/54907685/160722444-828fd712-2894-4f72-a409-9616376f46b2.png)

6. Scan is successfull!!

    ![Screen Shot 2022-03-29 at 4 25 56 PM](https://user-images.githubusercontent.com/54907685/160722486-cd057877-d0ca-46b2-bc00-73181245d110.png)


## Image scan vs Serverless scan
There are 2 types of scan which you can do:
1. Image scan - scanning an image for any known vulnerabilities. You saw the example for the same above.
2. Serverless scan - this scans your serverless functions (provided as a zip file) for scanning any known vulnerabilities.

For both type of scans, you will first need to run the curl command to download the relevant twistcli binary:

```curl -u $(PCC_USER):$(PCC_PASS) --output ./twistcli.exe $(PCC_CONSOLE_URL)/api/v1/util/windows/twistcli.exe```

Once successful, run the following resepctive command for each scan type:

For Image scan:
```./twistcli images scan  --address $(PCC_CONSOLE_URL) -u $(PCC_USER) -p $(PCC_PASS) --details $(image_name):$(tag)```

For serverless scan:
```./twistcli.exe serverless scan --address $(PCC_CONSOLE_URL) -u $(PCC_USER) -p $(PCC_PASS) --details $(FUNCTION_ZIP_NAME)```

Example screenshot for serverless scan:
  
  ![Screen Shot 2022-03-29 at 4 45 24 PM](https://user-images.githubusercontent.com/54907685/160724136-5ca46836-7992-4f72-b72f-f380543e510b.png)  


There are other options like --http-proxy or --project which can be used with these commands. For complete list, refer: https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin-compute/tools/twistcli_scan_images
