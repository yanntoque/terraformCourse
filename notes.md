# Notebook [Terraform Course on LinkedIn Formation](https://www.linkedin.com/learning/learning-terraform-2)

### Provider secret (AWS)

Register your credential in a secret file stored in `~/.aws/` 
* credentials file content :
     ```
     [default]
     aws_access_key_id=secret
     aws_secret_access_key=secret
    ```
## Exercise 1 : Deploying a resource (AWS S3 bucket)
### Terraform code 
`bucket.tf` where we specified the provider and resource configurations (aws and S3 bucket)

### Terraform commands 

`terraform init` To run in the terraform code directory, it initialize terraform and will look for any ```.tf``` file, analyze them and will download plugins.
 
![init](notesScreens/tfinit.png)

`terraform apply` 

![apply](notesScreens/tfapply.png)

The bucket has been created :
![AWSbucket](notesScreens/bucketCreatedByTF.png)

This is a very simple example. 


### How Terraform works 

In our example (deploying a resource), we might think why use terraform if we can do it with a script calling AWS API.

Terraform lets you define youre infrastructure as code, and gives a lot of flexibility in how you do that because you can freely use data from one resource to define another. In a non-Terraform script that just uses the API, you might deploy a couple of web servers and a load balancer. If you also want to add a new security group to function as a firewall, your script will need to call out to AWS, retrieve and process information describing those resources, and then take action to define your security group. With Terraform, that kind of sharing of data is trivial. Your code can define resources based on the definitions of other resources, even if they don't exist yet. That last point is critical. Terraform figures out the hard part of resource ordering and lets you just treat the infrastructure as static code.  

Terraform is taking the infrastructure described in your code and comparing it to the state of what actually exists, and then essentially writing a step by step script that will make the changes. The plan step is critical because it's the bit that figures out what needs to be done and in what order. Then, Terraform uses the provider to actually apply the plan and make whatever changes are needed.

Terraform uses a Directed Acyclic Graph where each node is a resource.

![DAG](notesScreens/graph.png)


### Terraform commands

`terraform plan` Generates an execution plan for Terraform.

This execution plan can be reviewed prior to running apply to get a
sense for what Terraform will do. Optionally, the plan can be saved to
a Terraform plan file, and apply can take this plan file to execute

We deployed our resource an S3 bucket earlier, this is the output the plan command :
![plan](notesScreens/tfplan.png)

`terraform plan -destroy` 
![plandestroy](notesScreens/tfplan-destroy.png)

It indicates the state of the resource and the action that will be done 

> Here we didn't specify the -out the plan is generated but not saved. 


`terraform plan -destroy -out=name.plan`

Setting the *-out* parameter lets you separate plan and apply 

![plandestroyout](notesScreens/tfplan-destroy-out.png)

This will save the plan as a binary file `destroy.plan` 

To show it use :  `terraform show destroy.plan`

To apply the plan :
`terraform apply destroy.plan`

![applydestroyplan](notesScreens/tfapply-destroy.png)

## Terraform State

Refers to two differents things:
* The reality of your infrastructure. What is the state of the resouces on AWS ? Their IP addresses, their instance type, bucket name ... 
* The local representation that Terraform keeps a `.tfstate` json file.

>It's entirely possible for those two to be out of sync, and Terraform doesn't know until it refreshes its local state. 











