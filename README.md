# Terraform

-> Terraform is a tool used to automate the deployment of infrastructure across multiple providers both in the public and private cloud. 


-> Infrastructure as code is provisioning infrastructure through software to achieve consistent and predictable environments. 


-> It's not a manual process. And the goal is to achieve consistent. That means every time that you use this software to deploy infrastructure, it does it in a consistent way and that the environment you get at the end is a predictable environment. It doesn't leave you guessing. It's going to look exactly like the configuration files say it should look. That's very important, especially when you have multiple environments that will be running the same version of an application.

-> Your infrastructure that you've defined in code should be stored in a versioned source control repository. There are two approaches roughly to implementing infrastructure as code. There's declarative or imperative.
Terraform is an example of a declarative approach to deploying infrastructure as code.


->Terraform attempts to be idempotent in the sense that if you haven't changed anything about your configuration and you apply it again to the same environment, nothing will change in the environment because your defined configuration matches the reality of the infrastructure that exists, and that's what's meant by idempotent.

-> In the world of infrastructure as code, Terraform is a push-type model. The configuration that Terraform has is getting pushed to the target environment. 

## Change of License and its impact
HashiCorp, the developer of Terraform, announced in 2023 a significant change in its licensing model. It has, therefore, changed the Terraform from MPL 2.0, which is an open-source license, to Business Source License (BSL), and it takes Terraform's code to build a competitive service for HashiCorp's solutions but gives non-commercial and individual usage rights. This ignited a huge row in the open-source community due to the fact that many organizations relied on Terraform due to its earlier license, which in effect has made it absolutely free to access and modify.

Changing the license for Terraform from MPL 2.0 to the Business Source License affects the users in the following ways:

- Commercial Restrictions- The users and organizations would be precluded from using the code for Terraform for building competing services or products. This, in turn, restricts customized versions of Terraform, mainly on commercial levels, to third-party providers who will create and distribute them.

- Non-commercial use: Virtually nothing changes for the individual, hobbyist, or non-commercial users.  They still use Terraform pretty much as before, but they need to be attentive to changes and shifts in policy that may bear upon their usage rights.