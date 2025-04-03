from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import ECS, EC2, ElasticContainerServiceContainer
from diagrams.aws.network import ELB, VPC, InternetGateway, NATGateway
from diagrams.aws.management import CloudwatchLogs
from diagrams.aws.general import Users, Client

# Set diagram attributes: horizontal spacing between nodes and default font size
graph_attr = {
    "nodesep": "2.0",
    "fontsize": "24"
}

# Set node attributes: font size for node labels
node_attr = {
    "fontsize": "16"
}

output_file = "infra_task_architecture"
with Diagram("Test Task Architecture", show=False, filename=output_file, 
             direction="TB", graph_attr=graph_attr, node_attr=node_attr):
    
    with Cluster("External Users"):
        admin = Client("Admin")
        users = Users("Users")
    
    # Define VPC
    with Cluster("VPC (10.0.0.0/16)"):
        igw = InternetGateway("Internet Gateway")
        bastion = EC2("Bastion Host")
        
        # Define ECS Cluster containing all components
        with Cluster("ECS Cluster"): 
            alb = ELB("ALB")
            
            # Define AZs, subnets, NAT GTW, Fargate Tasks
            with Cluster("Availability Zone 1"):
                with Cluster("Public Subnet 1"):
                    nat_gateway1 = NATGateway("NAT GTW 1")
                with Cluster("Private Subnet 1"):
                    fargate_task1 = ElasticContainerServiceContainer("Fargate Task 1")
            
            with Cluster("Availability Zone 2"):
                with Cluster("Public Subnet 2"):
                    nat_gateway2 = NATGateway("NAT GTW 2")
                with Cluster("Private Subnet 2"):
                    fargate_task2 = ElasticContainerServiceContainer("Fargate Task 2")
        
    cloudwatch = CloudwatchLogs("CloudWatch Logs")
    
    # Create connections
    users >> Edge(label="HTTP", minlen="2") >> igw
    admin >> Edge(label="SSH", minlen="2") >> bastion
    igw >> Edge(minlen="2") >> alb
    igw >> Edge(minlen="2") >> nat_gateway1
    igw >> Edge(minlen="2") >> nat_gateway2
    alb >> Edge(minlen="2") >> fargate_task1
    alb >> Edge(minlen="2") >> fargate_task2
    nat_gateway1 >> Edge(minlen="2") >> fargate_task1
    nat_gateway2 >> Edge(minlen="2") >> fargate_task2
    fargate_task1 >> Edge(minlen="2") >> cloudwatch
    fargate_task2 >> Edge(minlen="2") >> cloudwatch
    bastion >> Edge(style="dashed", minlen="2") >> fargate_task1
    bastion >> Edge(style="dashed", minlen="2") >> fargate_task2
    igw >> Edge(style="invisible", color="white") >> alb
    alb >> Edge(style="invisible", color="white") >> cloudwatch