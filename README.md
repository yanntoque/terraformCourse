# Notes taken while following the course [Terraform Course on LinkedIn Formation](https://www.linkedin.com/learning/learning-terraform-2)

### Provider secret (AWS)

Register your credential in a secret file stored in `~/.aws/` 
* credentials file content :
     ```
     [default]
     aws_access_key_id=secret
     aws_secret_access_key=secret
    ```
## Deploying a resource (AWS S3 bucket) (`bucket/` folder)
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

> If you use this plan it will go stale. That's why if you redeploy the bucket you will need to remake a plan for destroying the resource

## Terraform State


Refers to two differents things:
* The reality of your infrastructure. What is the state of the resouces on AWS ? Their IP addresses, their instance type, bucket name ... 
* The local representation that Terraform keeps a state file `.tfstate` which has a json format
  
>It's entirely possible for those two to be out of sync, and Terraform doesn't know until it refreshes its local state.

#### Local terraform state
`.tfstate` after destroying, changing the bucket name in `bucket.tf`and applying it :
![localstate](notesScreens/tfstate.png)

#### Remote State Storage (using Terraform [Backend Feature](https://www.terraform.io/docs/backends/index.html))
Terraform state can be stored remotely, Remote storage is something you'd have to set up if you were working on a team using a feature Terraform call [Backends](https://www.terraform.io/docs/backends/index.html). 

Remote storage of state prevents a team from stomping on each other's changes and allows teams to do things like delegate and share resources. For example, you could allow some users read-only access to certain details of the infrastructure, but still let Terraform run as though it had full access, as long as it didn't change this. 

#### Terraform state command (preferred way of investigating at terraform state)

`terraform state`  

 ##### Altering state

Messing with the state and the state file is something to try to avoid at all cost. It is needed sometimes. Sometimes things can get just a little bit out of sync, and Terraform can't recover itself. But that is an advanced thing on a large infrastructure and messing with state shouldn't be done lightly.

##### Read Only subcommands
* `terraform state list` 
    
    List of types and names of resources provisioned :
    ![tfstatelist](notesScreens/tfstate-list.png)

* `terraform state list resourcename` 
  
  Dig in a little bit deeper on a specific resource :
![tfstateshowresource](notesScreens/tfstate-show-resource.png)


`terraform show` see the entire state file 
`terraform show -json` will show a JSON representation of the state 


### Terraform graph command 


`terraform graph`
![tfgraph](notesScreens/tfgraph.png)

The syntax is known as DOT for DOT file (common way to defining graphs like this). To see it generate the graph visually, there is an open source webtool called : [WebGrpahViz](http://webgraphviz.com/)

![webgraphvizGeneratedGraph](notesScreens/webgraphvizGeneratedGraph.png)

This is the graph for our simple case of providing an S3 bucket.
Nodes can be run in parrallel. 
Diamonds shape are for providers.

## Deploying a bucket, VPC,a SecurityGroup

`prod/` -> create our infra -> `prod.tf`
We have 3 resource a bucker, a VPC and a security group
`terraform init` (check for `.tf` file and download plugins)
`terraform plan` (showing the plan)
`terraform apply` 

![prodtfapply](notesScreens/prod-tfapply)
