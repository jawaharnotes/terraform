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





































