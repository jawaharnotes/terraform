# terraform
This repo i use to create all basics terraform use cases and its explanation 

<img width="1566" height="491" alt="image" src="https://github.com/user-attachments/assets/693c377e-4e58-4251-b7ed-698db8a55c57" />


<img width="1379" height="349" alt="image" src="https://github.com/user-attachments/assets/225dd664-216b-45af-b796-e350163fbeb1" />

Getting the details of the existing VPC using datasource

Get the corresponding VPC ID
<img width="1873" height="567" alt="image" src="https://github.com/user-attachments/assets/eac29f5d-2210-4ea0-9661-f026d1eaa976" />

Write the VPC.tf 

<img width="1408" height="396" alt="image" src="https://github.com/user-attachments/assets/ac70d2ea-a99a-4c94-a658-027b6b00cbc5" />


we had a small typo got corrected . Hasicorp to Hashicorp

<img width="1726" height="525" alt="image" src="https://github.com/user-attachments/assets/3d77e5aa-be02-4716-94b6-a1c5e2d32023" />

Then Gave terraform provider to get the details of provider 
Then Terraform init will download all the required details from provider and creates the lock file


<img width="1783" height="1081" alt="image" src="https://github.com/user-attachments/assets/160946b0-7bf2-439c-b642-dd6e02366f99" />

<img width="1544" height="771" alt="image" src="https://github.com/user-attachments/assets/085c08a0-a71f-43d9-a88a-f9cbf4a92f85" />

So a lock file and a provider is getting created 

<img width="1754" height="478" alt="image" src="https://github.com/user-attachments/assets/395fecb4-fa60-4152-8ed2-59f7045fcc13" />

If we do terraform plan now it will fail, Since we have not configured any of the creds 

<img width="1696" height="598" alt="image" src="https://github.com/user-attachments/assets/ea225936-c4a0-4e95-9fbb-3ffaf061f0fc" />

Now, we need to create a user for this terraform .
We will create a terraformAdmin group with admin access to that group and add the user.

Creating the Group:
<img width="1885" height="910" alt="image" src="https://github.com/user-attachments/assets/6a0d3690-594b-4738-a764-bb035d234f91" />

<img width="1915" height="550" alt="image" src="https://github.com/user-attachments/assets/3327292a-bac2-44b6-8d83-30492a073f26" />

Creating the User:

<img width="1900" height="698" alt="image" src="https://github.com/user-attachments/assets/38ee8f8b-a0eb-4928-ba07-081addad7d6f" />

<img width="1901" height="985" alt="image" src="https://github.com/user-attachments/assets/5411687f-3b46-491c-ba22-f5df1c5c6e94" />

<img width="1894" height="944" alt="image" src="https://github.com/user-attachments/assets/fffdcbcd-ff12-4295-869b-d82ac26a3e39" />

Creating creditential for the User:
Access key:
<img width="1902" height="994" alt="image" src="https://github.com/user-attachments/assets/63fb07f8-ac1a-4550-823f-ab4fdba905e2" />

<img width="1910" height="911" alt="image" src="https://github.com/user-attachments/assets/a06f097c-e9c2-4ea2-90cd-c5c2d3945602" />

<img width="1907" height="659" alt="image" src="https://github.com/user-attachments/assets/c42263ac-6339-4e50-9bad-1134d654eee1" />

<img width="1914" height="926" alt="image" src="https://github.com/user-attachments/assets/0e82d161-9d01-428e-9880-898b90f137d5" />

<img width="1902" height="644" alt="image" src="https://github.com/user-attachments/assets/9b9c38c9-16d1-4a39-b95f-47fcd9b309b2" />

How It Works :

Access key and secret access key are for programatic access . Like our human user name and passwords.

How terraform will work with these :

Terraform does not store credentials itself. It uses the AWS SDK (the same as the AWS CLI), which follows a standard search order called the credential chain:

Environment variables
AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_SESSION_TOKEN

Shared credentials/config files

~/.aws/credentials (from aws configure)

~/.aws/config

CLI profiles (e.g. --profile myprofile or provider { profile = "myprofile" })

EC2/ECS IAM roles (if Terraform runs inside AWS, it can fetch temporary creds from the instance role).

How :

When we run

terraform plan


Terraform checks the provider block:

provider "aws" {
  region = "ap-south-1"
}


Region = ap-south-1

Then Terraform asks the AWS SDK:
“Give me credentials.”

The SDK goes through the chain (env vars → files → IAM role).
If you ran aws configure, it finds ~/.aws/credentials:

[default]
aws_access_key_id = ABC123...
aws_secret_access_key = AbCdEfGh...


Terraform uses these keys to sign API requests.
Example: To read VPC info (data "aws_vpc" ...), it calls AWS API:
DescribeVpcs → AWS checks your IAM permissions → returns VPC details.

Flow:

So the logic is:
 Terraform itself does not store credentials.
 It asks the AWS SDK, which follows the credential chain to find your access key + secret key.
 With them, it signs API requests → AWS authenticates → IAM authorizes → Terraform creates/manages resources.


Profiles:

A profile is just a named set of AWS credentials and configuration stored in your local machine (usually in ~/.aws/credentials and ~/.aws/config).
A label for a specific AWS account or role.

We have default and custom Profile
Default:
 Which terraform connects for the fall back if no profile explicitely set up
Custom :
 User defined Profile . For the first time, we will set it up using this 

[Default]
key_id:
secret:

[prod]
key_id:
secret:

[QA]
key_id:
secret:

Creating the Custom Profile for us using the keys we generated:

Requirement :
aws cli needs to be preinstalled 

$ aws --version
$ aws configure  --profile terraformUser

enter the access key id and secret access key id .

$ aws sts get-caller-identity --profile terraformUser
gives us the details of the userID , aws account details 
$ cd ~./aws
$ cat credentials 
We can now see the custom profile and creds
$ cat config
Profile will be listed

<img width="1619" height="1094" alt="image" src="https://github.com/user-attachments/assets/255ccdbe-dc27-4de3-8706-36e1257ed8a4" />

Now we have the profile , we will pass it to the provider and run the plan

<img width="1753" height="643" alt="image" src="https://github.com/user-attachments/assets/c72b8f18-dcd2-4558-b763-d66e5ae332f8" />

$ terraform plan

<img width="1802" height="315" alt="image" src="https://github.com/user-attachments/assets/485939aa-71b3-48aa-9a2d-a2b485e17a41" />


Now, Instead of using Static User , we shall use the IAM Roles :

we can have roles like terraform-[admin, viewer, planner, user]


















