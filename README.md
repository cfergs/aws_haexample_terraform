# aws_haexample_terraform
Example of a AWS highly available setup over 2 availability zones. Please note NAT gateways are not part of the AWS free tier so this will cost a few cents to deploy.

![Image]("/assets/haexample_diagram.jpg")

### Usage
#### Step 1 - Credentials
You will need to update value **shared_credentials_file** in variables.tf with your credential file location. Feel free to change the region as you desire.

#### Step 2 - Terraform Run
Change the current directory to `aws_haexample_terraform` and execute the following  
```
$ terraform init
$ terraform plan
$ terraform apply
```

Upon creation the website URL will be visible in the cmd prompt 

```
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

website = http://lb-1342713067.ap-southeast-2.elb.amazonaws.com
```

### Cleanup Tasks
When complete make sure to destroy your resources to minimise further charges!

```
terraform destroy
```