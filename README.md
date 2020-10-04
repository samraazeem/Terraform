# Terraform

-> Terraform is a tool used to automate the deployment of infrastructure across multiple providers both in the public and private cloud. 


-> Infrastructure as code is provisioning infrastructure through software to achieve consistent and predictable environments. 


-> It's not a manual process. And the goal is to achieve consistent. That means every time that you use this software to deploy infrastructure, it does it in a consistent way and that the environment you get at the end is a predictable environment. It doesn't leave you guessing. It's going to look exactly like the configuration files say it should look. That's very important, especially when you have multiple environments that will be running the same version of an application.

Your infrastructure that you've defined in code should be stored in a versioned source control repository. There are two approaches roughly to implementing infrastructure as code. There's declarative or imperative.

Terraform is an example of a declarative approach to deploying infrastructure as code.


->Terraform attempts to be idempotent in the sense that if you haven't changed anything about your configuration and you apply it again to the same environment, nothing will change in the environment because your defined configuration matches the reality of the infrastructure that exists, and that's what's meant by idempotent.

 In the world of infrastructure as code, Terraform is a push-type model. The configuration that Terraform has is getting pushed to the target environment. 
