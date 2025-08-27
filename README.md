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

--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
Terminology:

Policy:
A document which has permissions. Like list all VPC instances 
Policies can be directly assigned to a user/roles

Role:

An identity that has set of permissions(thru policies)
Doesnot have long term creds (username/passwords or access keys)
     A role is like a uniform. When you "assume" a role, you temporarily wear that uniform and get its permissions.

User:
Is a real person or application.
Has long term creds(passwords or access keys)
Service access ( s3 can talk to Ec2 without access keys)

Roles or User :
Roles can take temporary permissions
cross account access



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

Retrieve the current user from AWS and verify authentication. Gives us the details of the userID , aws account details 
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
Like Admin can provide resources , Viewer can plan the things

Creating the Role:

<img width="945" height="886" alt="image" src="https://github.com/user-attachments/assets/0ecd5dd2-76e2-46fa-9d39-7480cdd5a88f" />

In Real world, we will have custom Admin roles 
<img width="939" height="984" alt="image" src="https://github.com/user-attachments/assets/f6b16fc5-c4bd-4fc7-a44d-259a24de13fc" />

Terraform-admin role created with AWSadmin access
<img width="1250" height="989" alt="image" src="https://github.com/user-attachments/assets/86f33949-eb98-4714-889f-7745bfa24774" />

terraform-admin Role created
<img width="1258" height="978" alt="image" src="https://github.com/user-attachments/assets/52814bd8-9807-4060-b0b5-ddf5428de41b" />

<img width="1257" height="909" alt="image" src="https://github.com/user-attachments/assets/f4ee213f-40e2-41aa-b266-5a7a9a112dbb" />

--------------------------------------------------------------------------------------------------------------------------------------------

Assume Role concept:

aws sts assume-role \
 --role-arn arn:aws:iam::283670584284:role/terraform-admin \
 --role-session-name terraform \
 --profile terraformUser
1. aws sts assume-role
Uses STS (Security Token Service) to assume (take on) another IAM role.

Instead of using your normal IAM user directly, you “step into” the role, and AWS gives you temporary credentials (Access Key, Secret Key, Session Token).

2. --role-arn arn:aws:iam::283670584284:role/terraform-admin
The ARN (Amazon Resource Name) of the IAM Role you want to assume.

In this case: the terraform-admin role in account 283670584284.

This role probably has Admin or restricted permissions used for Terraform resource provisioning.

3. --role-session-name terraform
Just a label for your temporary session.

You can put any string here (like ci-cd-run or jawahar-session).

It’s useful for CloudTrail logs to track who assumed the role.

4. --profile terraformUser
This tells the AWS CLI which credentials to use to request the role.

For example:

Your IAM user terraformUser might have only permission to assume roles, not to create AWS resources directly.

So you first authenticate as terraformUser, then assume terraform-admin role → and get full admin permissions temporarily.

 What happens internally
You (logged in as terraformUser) call AWS STS.

AWS checks if terraformUser has permission (sts:AssumeRole) to assume terraform-admin.

If yes, AWS gives you temporary credentials (valid for 1 hour or so):

AccessKeyId

SecretAccessKey

SessionToken

These credentials are returned as JSON → you can export them into your shell and Terraform will use them.

Example output:

json
{
  "Credentials": {
    "AccessKeyId": "ASIAxxxxxxx",
    "SecretAccessKey": "abcdxxxxxxx",
    "SessionToken": "FQoGZXIvYXdzE...",
    "Expiration": "2025-08-25T12:34:56Z"
  },
  "AssumedRoleUser": {
    "AssumedRoleId": "AROAxxxxxxxxx:terraform",
    "Arn": "arn:aws:sts::283670584284:assumed-role/terraform-admin/terraform"
  }
}
 
 
 Why use this instead of direct IAM user?
Best practice in AWS:

Users (like terraformUser) should have minimal rights (only assume roles).

Roles (like terraform-admin) should hold powerful permissions.

This way:

Users don’t keep long-lived admin credentials.

If temporary keys leak → they expire.

More secure + auditable.

In short:
This command lets your terraformUser temporarily become terraform-admin by assuming the role via STS. Terraform will then use those temporary credentials to manage resources.

---------------------------------------------------------------------------------------------------------------------------------------------------
AWS security Token service :

aws sts assume-role \
 --role-arn arn:aws:iam::283670584284:role/terraform-admin \
 --role-session-name terraform \
 --profile terraformUser

TerraformUser assigned the Role - terraform-admin (which has full admin access) for short duration of time.
In real life, TerraformUser will never have its own admin access( which we provided during its creation) . It will have some limited permisssion like assuming roles only.

<img width="1903" height="577" alt="image" src="https://github.com/user-attachments/assets/886e6068-f56c-49f0-8486-100097303ba8" />

Making Terraform-user to have only assume-role policies :
Specific user assuming specific IAM roles:

Creating the new Policies:

Pre steps:
Removing the FullAdmin access from the terraformAdmin group which has the terraformUser and Administrator access . removing from group applies for all users in it .

<img width="975" height="876" alt="image" src="https://github.com/user-attachments/assets/8f066ae3-2a02-43f1-aa18-c6d426826ca4" />

<img width="1086" height="706" alt="image" src="https://github.com/user-attachments/assets/2a13ca53-587e-4a8a-bb7b-7a3f6c09e7f0" />

Add only the VPCfull access now 
<img width="1082" height="949" alt="image" src="https://github.com/user-attachments/assets/6322e178-8011-4688-8b53-9259ae0e4df7" />

Now our user terraformUser has the full VPC access but not fulladminAccess. So vpc_cidr will work 

<img width="1278" height="368" alt="image" src="https://github.com/user-attachments/assets/24fa7593-d587-4145-a205-607bf67f819c" />

Now, assume the terraform-admin Role( which has fullAdmin access ) but you (terraform-user) has only VPCadminaccess. You dont have the assume privilege . 
Only fulladminaccess has the assume privilege 

aws sts assume-role \
 --role-arn arn:aws:iam::283670584284:role/terraform-admin \
 --role-session-name terraform \
 --profile terraformUser

Will result in Error 

<img width="1280" height="230" alt="image" src="https://github.com/user-attachments/assets/98549462-f83f-44ee-a6a2-051c2e1fbe10" />

So, lets create the new policy 

<img width="1100" height="884" alt="image" src="https://github.com/user-attachments/assets/b9197d7a-30f9-4e76-9620-8ca90e8819b8" />


  Role selection :
   <img width="1084" height="987" alt="image" src="https://github.com/user-attachments/assets/957d073d-5bad-4c5f-a8e5-73587177ec95" />

<img width="1093" height="958" alt="image" src="https://github.com/user-attachments/assets/0bd2a653-6717-470e-9cdb-648fe94d09a4" />

<img width="1096" height="981" alt="image" src="https://github.com/user-attachments/assets/2ec7c3fb-b755-4f0d-b398-a62277ca3dda" />

Policy Created:

<img width="1094" height="807" alt="image" src="https://github.com/user-attachments/assets/2ae24f07-2e04-402d-8e01-1f7b129a232d" />

Associate this policy with our user group so that our terraformUser will get this policy which created .

So flow is 

Policy - (has the required role selected) ---> UserGroup ---> User

First delete the policy which we currently assigned 

<img width="1095" height="729" alt="image" src="https://github.com/user-attachments/assets/6b7d1e4c-9c41-473f-9d60-6b340f1ef3e5" />

Then attach the newly created Assumeonlyadmin policy

<img width="1095" height="533" alt="image" src="https://github.com/user-attachments/assets/1fed6c35-3a09-4a8b-9ff8-2a29b62cfaef" />


Now it will work by executing aws sts assumerole 

<img width="1284" height="776" alt="image" src="https://github.com/user-attachments/assets/57c79d72-459b-4e35-b874-64b5128b07fd" />

But Terraform Plan will be failing , because terraformUser now only has the assume role configured

<img width="1276" height="850" alt="image" src="https://github.com/user-attachments/assets/4e661d6f-48bf-4a01-8cd4-399663c6d709" />


<img width="1271" height="905" alt="image" src="https://github.com/user-attachments/assets/fc3911e2-e151-4447-8169-9b2b77b86e97" />

<img width="1278" height="338" alt="image" src="https://github.com/user-attachments/assets/31b6d849-f8f1-4c26-bf85-a6460fcfce8d" />


Apply our role in the place of profile

<img width="1746" height="731" alt="image" src="https://github.com/user-attachments/assets/8c60a4c5-1af8-4e1a-bb63-e8fdcefe7416" />

$terraform apply
It works now 

<img width="1271" height="554" alt="image" src="https://github.com/user-attachments/assets/46d20433-6388-4385-8a19-a5194661fe0a" />

State file will be updated 

<img width="1834" height="1060" alt="image" src="https://github.com/user-attachments/assets/82e4bdac-e692-4f6a-b585-47e42f8cd42b" />

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

what happens in above steps :

The ~/.aws/config block
[profile terraformUser]

[profile terraform-admin]
role_arn = arn:aws:iam::283670584284:role/terraform-admin
source_profile = terraformUser

1. [profile terraformUser]

This is just the base profile.

You’ll have its real credentials in ~/.aws/credentials:

[terraformUser]
aws_access_key_id = AKIAxxxxxx
aws_secret_access_key = Xxxxxxxx


This means Terraform/CLI can log in as terraformUser.

2. [profile terraform-admin]

This is a chained profile (role-based).

It says:

role_arn = arn:aws:iam::283670584284:role/terraform-admin
→ “When I use this profile, I want to assume the terraform-admin role.”

source_profile = terraformUser
→ “Use terraformUser’s credentials as the starting point to request the role.”

🔹 What happens behind the scenes

When you run:

aws sts get-caller-identity --profile terraform-admin


AWS CLI reads ~/.aws/config.

It sees: “terraform-admin depends on terraformUser.”

CLI uses terraformUser’s credentials (from ~/.aws/credentials).

It calls sts:AssumeRole for terraform-admin.

AWS returns temporary credentials.

Now your CLI session (or Terraform) runs as terraform-admin, not terraformUser.

🔹 Why is this needed?

Without the ~/.aws/config chaining:

You’d have to manually run aws sts assume-role ... and export temporary keys each time.

With the chaining setup → Terraform/CLI automatically assumes the role for you whenever you use --profile terraform-admin.

👉 This is why you added that block — it automates the assume-role step.

✅ In summary:

terraformUser = real IAM user with keys, but minimal rights (only assume roles).

terraform-admin = IAM role with admin permissions.

~/.aws/config ties them together so that when you use profile terraform-admin, AWS CLI/Terraform first logs in with terraformUser, then assumes the terraform-admin role automatically.

Our Role terraform-admin has 2 jobs here 
1. Administartor access
2. giving its permission to terraform-user for short duration


   <img width="1706" height="791" alt="image" src="https://github.com/user-attachments/assets/86a9e4f8-eeac-41c9-aa5d-6b223f47a00e" />

   who ever having the assumerole they can get terraform-admin privilige

   <img width="1720" height="672" alt="image" src="https://github.com/user-attachments/assets/6eefdd81-bba9-4eca-9705-1611d9874221" />

  As, user(terraformUser ) has the assume policy

  <img width="1714" height="772" alt="image" src="https://github.com/user-attachments/assets/b633c035-059d-40d8-b7d4-c0ce7aa662f2" />

Summary:
Once terraformUser assumes the role terraform-admin using the creds in ~/.aws/credientials

The session drops all original terraformUser permissions. And takes the terraform-admin role 

It only inherits the permissions granted to the role terraform-admin (e.g., AdministratorAccess).

So effectively:

terraformUser → allowed to assume terraform-admin role

terraform-admin role → has AdministratorAccess (full admin)

End result → terraformUser can temporarily get full admin rights by assuming the role.


your role (terraform-admin) has two pieces in play:

A trust policy (defines who can assume it).

A permissions policy (defines what actions the role can perform, e.g., AdministratorAccess).

And your user (terraformUser) has the assumeadmin policy so it is allowed to jump into this role.

USer has this Group:
<img width="1718" height="866" alt="image" src="https://github.com/user-attachments/assets/d6b470b3-66b1-4431-a9ed-fb164a7d0c05" />
Permission(policy): Assumeadmin
<img width="1728" height="954" alt="image" src="https://github.com/user-attachments/assets/b95d3934-236a-4962-a3da-fa3460e08942" />

Policy has this STS- Assume + Adminrole
<img width="1733" height="727" alt="image" src="https://github.com/user-attachments/assets/bb66a094-1ab2-48cb-a450-b6ec56259016" />

<img width="1714" height="795" alt="image" src="https://github.com/user-attachments/assets/6a3c22df-e2e0-4e5f-9338-4693780ae626" />


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


Installating EC2 Instance :

Concepts:

AMI - Amazon Machine images 
  It is template which defines us Software categores like OS, pre installed application and certain required  permissions or configs . 
  Example : Ubuntu OS + Nginx pre installed + Have root previliege, how volume is mounted 
Instance type 
  It is Hardware category . Defines Hardware things Memory, Storage, CPU , IOPS etc 

Creating the EC2 Instance :

<img width="1519" height="446" alt="image" src="https://github.com/user-attachments/assets/73c32830-6f30-4b68-9484-d8f54dce1a5b" />

Terraform plan

<img width="1558" height="1040" alt="image" src="https://github.com/user-attachments/assets/abd2665f-920f-4199-921e-51812e22ed71" />

<img width="1476" height="1100" alt="image" src="https://github.com/user-attachments/assets/672b5856-57cb-425a-af95-69b9a07df051" />

Always make sure what it is going to do 

Terraform validate
  It will validate whether our file /configuration looks correct.
  Checks if  Terraform configuration files are syntactically valid and internally consistent.

  It does not check with AWS (or any cloud) to see if resources actually exist.
  It does not download AMIs, subnets, or validate credentials.
  It does not show you what will be created/changed.
  
<img width="1135" height="139" alt="image" src="https://github.com/user-attachments/assets/56e5ff19-e61c-4215-80df-a3b0bb737b63" />


Terraform apply

<img width="1868" height="1092" alt="image" src="https://github.com/user-attachments/assets/e5f0fdeb-a4e2-4b37-83d8-65629add26af" />

<img width="1689" height="1000" alt="image" src="https://github.com/user-attachments/assets/acd75d40-b4a4-4bca-91a5-87133b4ba88f" />

It will ask for permission to proceed - YES, Resource will get created 

<img width="1077" height="299" alt="image" src="https://github.com/user-attachments/assets/64964c56-bf7c-4ed4-b389-79b6e93fa3db" />


Validation in COnsole:

<img width="1914" height="988" alt="image" src="https://github.com/user-attachments/assets/79e0fbad-69bc-41c3-8ed7-8281dee8ab29" />

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

What happens in Backend now:
Read Config Files
1. Terraform init
   Downloads all the necessary providers
   Sets up Backend state storage

2.Terraform loads your .tf files.
Example:

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"
}


It parses HCL and builds a dependency graph (knows what to create first).
(e.g., if you had a VPC + EC2, Terraform creates the VPC first).

3. Load Provider Credentials

Terraform checks how to connect to AWS:

From ~/.aws/credentials or ~/.aws/config.

Or AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY environment vars.

Or an assumed IAM role.

Uses these creds to authenticate with AWS APIs.

4. Refresh State

Terraform compares your current state file (terraform.tfstate) with real AWS resources.

If no state exists (first run), Terraform assumes nothing exists yet.

5. Execution Plan

Terraform builds an execution plan:

“Since EC2 doesn’t exist yet, I need to create it.”

Shows you the plan (if you ran terraform plan explicitly).

With terraform apply, it generates the plan and asks for approval:

An execution plan has been generated...
+ aws_instance.myec2 will be created

6. Apply (Actual Creation in AWS)

After you confirm (yes):

Terraform makes an API call to AWS EC2 service via the provider plugin:

POST https://ec2.amazonaws.com/
Action=RunInstances
&ImageId=ami-0abcdef1234567890
&InstanceType=t2.micro


AWS processes the request and spins up the EC2 instance.

AWS returns metadata: instance ID, IP, etc.

7. Update State

Terraform writes details into the state file (terraform.tfstate):

{
  "resources": {
    "aws_instance.myec2": {
      "type": "aws_instance",
      "primary": {
        "id": "i-0123456789abcdef0",
        "attributes": {
          "ami": "ami-0abcdef1234567890",
          "instance_type": "t2.micro",
          "public_ip": "13.234.22.10"
        }
      }
    }
  }
}


This state file is Terraform’s “memory” of what exists in AWS.

8. Success

Terraform prints output:

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Any chnages to the ec2 instance:

Chnaged the instance type from micro to small

<img width="1509" height="520" alt="image" src="https://github.com/user-attachments/assets/b6cd91cc-84c3-44e9-9e54-44e7921ff7b8" />

Terraform plan

<img width="1889" height="694" alt="image" src="https://github.com/user-attachments/assets/6add7f68-02eb-4c9b-98b2-c43e57a6b04c" />

terraform plan -out instancechnage.txt

<img width="1784" height="770" alt="image" src="https://github.com/user-attachments/assets/2042f752-be04-412e-834a-b0d3d97732b0" />

Terraform apply instancechnage.txt

<img width="1896" height="692" alt="image" src="https://github.com/user-attachments/assets/35483f56-d174-41a8-8252-fd0f6684496c" />

It will stop the excisting instance and chnage to t2.small

<img width="1896" height="692" alt="image" src="https://github.com/user-attachments/assets/1573fc23-0c01-45a6-ace9-a4809931dadc" />


In State file it will be recorded

<img width="1501" height="1019" alt="image" src="https://github.com/user-attachments/assets/d4eae6fa-140b-4d61-90e4-abcb4b4c75ad" />


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Target:

In a large scale enterprises, There may be 2 person who are working on the same file for two different resources 

For example , i chnaged my ec2 instance back to t2.micro

<img width="1506" height="481" alt="image" src="https://github.com/user-attachments/assets/d8db640c-892f-4393-af2a-8a467e4c4dd1" />

To apply only those resource 

terraform apply -target aws_instance.ubuntu

<img width="1882" height="874" alt="image" src="https://github.com/user-attachments/assets/b597d0ea-3177-4d1e-8413-f28339f1c450" />

<img width="1280" height="701" alt="image" src="https://github.com/user-attachments/assets/112fdbb8-4186-4974-8cfd-5a672154b5e7" />

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Importing existing ec2 into Terraform :

suppose if you have made chnages in the console. Then we need to import all the modification to the Terraform :

So , i voluntarily go and chnage the ec2 instance type in console

t2.micro to t2.small

<img width="1917" height="961" alt="image" src="https://github.com/user-attachments/assets/2351a3f0-657c-452e-a0ea-42d454f081cf" />

<img width="1902" height="650" alt="image" src="https://github.com/user-attachments/assets/97054178-e03c-451a-b111-e5199df09974" />

Now if we do terraform plan . It will say to migrate from small to micro . Because terraform knows micro is the correct one which is in our file

terraform import aws_instance.ubuntu <corresponding ec2 instance id>

<img width="1250" height="383" alt="image" src="https://github.com/user-attachments/assets/166e54ec-45dd-4bee-a51f-096d4a9fe540" />


In this case , we need to take decision to migrate small to micro , or change the file to small

I changed the file 
<img width="1178" height="380" alt="image" src="https://github.com/user-attachments/assets/ccfa7981-3c98-48d3-9f98-cd2d777cfebb" />

It says no changes

<img width="1269" height="260" alt="image" src="https://github.com/user-attachments/assets/163a5768-67d6-4232-9fb6-e82cb33f400d" />

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

How to remove the ec2 instance from terraform but not destroy:

If we comment out ec2 resource , it will destroy it

<img width="1105" height="430" alt="image" src="https://github.com/user-attachments/assets/54cb1089-8b3d-4980-a785-e7e990c3fa36" />

terraform plan
<img width="1274" height="921" alt="image" src="https://github.com/user-attachments/assets/66542175-b890-4673-bb49-e24ed4a8bf8a" />


So, we shall use terraform state rm aws_instance.ubuntu

<img width="1478" height="127" alt="image" src="https://github.com/user-attachments/assets/772fb89e-c593-4392-9ad6-b2cac31cf44b" />

It will remove the aws_instance from the state file, but resource will be running in AWS

<img width="1844" height="1032" alt="image" src="https://github.com/user-attachments/assets/59d1a575-a948-4ccd-931b-54f77868e46d" />

<img width="1909" height="569" alt="image" src="https://github.com/user-attachments/assets/c8c519e2-7839-4ad9-aae3-c373d38ac279" />


If we terraform plan again keeping the aws_instance resources active in files . It will plan to deploy again . So, we can either remove the aws_instance from file or delete the resource from console if not required 

<img width="1896" height="1035" alt="image" src="https://github.com/user-attachments/assets/7b290b78-cd82-4c82-8103-33538ac69f15" />

So, Deleted the instance from AWS console

<img width="1907" height="600" alt="image" src="https://github.com/user-attachments/assets/b3767207-900a-4f54-8ddd-4465911e60e3" />

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Another important command :

Terraform refresh 

If we created the Ec2 instance using terraform with type=t2.micro using terraform config 
Then if some one in webconsole chnaging it to t2.small

Now the real-world AWS resource = t2.small,
but Terraform’s state file still says t2.micro.


$terraform refresh
Terraform queries AWS: “Hey, what’s the actual type of i-123456789?”
AWS responds: t2.small.

Terraform updates terraform.tfstate -> sets instance_type = t2.small.

Very important -> It UPDATES ONLY STATE FILE . IT WONT TOUCH OUR INFRA OR RESOURCE CONFIG FILE.

Now, 
AWS Console -> t2.small
state file -> t2.small
Terrform resource config -> t2.micro

If we do the terraform plan .

Terraform will try to set the resource to t2.micro . Because it sees the drift between configuration and state file . It goes along with the configuration file.

terraform refresh ---> check the real world and update my state file, don’t touch infra.”




































































