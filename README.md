# MongoDB with replicaSet on AWS EC2
The script can be used to get create EC2 Cluster along with VPC, Subnet, etc in AWS Cloud

## Requirements
Install terraform

## Steps

1. Create a copy of vars file inside env folder with name equals to the environment name

2. Now run the `deploy.sh` with appropriate command and the env name
    
    `deploy.sh create dev`
    
    `P.S: There should be dev.tfvars files available inside the env folder`

## Commands
A list of commands available:

1. `create` : This will create and configure a new VPC, subnets, etc
`example: ./deploy.sh create dev`

2. `update` : This will update the network setup
`example: ./deploy.sh update dev`

## Tfvars Arguments:
Following arguments are available:

key_name (required): Name of the pem key file to use for instances

vpc_cidr (required): CIDR range need to specify to create vpc

environment (required): Name of the env where you are launching.

public_subnets_cidr (required): CIDR range need to specify to create public subnet

private_subnets_cidr (required): CIDR range need to specify to create private subnet

availability_zones (required): Avaibility zone to create subnet in specific zone. e.g us-east-1c

bucket(required): Name of s3 bucket to store the state

key(required): Name of the folder/state file. Example: terraform/tfstate

## Setup MongoDB replication on EC2 nodes

1.  Login into one of the mongo EC2 node.

2.  Exec into container
   
    `docker exec -it mongonode /bin/bash`

3.  Access mongo console using below command
   
    `mongo`

4.  Configure replica set by pasting the following
   
   `rs.initiate(
      {
        _id : 'rs0',
        members: [
          { _id : 0, host : "YOUR_LOCAL_IP:27017" },
          { _id : 1, host : "YOUR_LOCAL_IP:27017" },
          { _id : 2, host : "YOUR_LOCAL_IP:27017" }
        ]
      }
    )`

5.  Use below command to list the DB's
   
    `show dbs`

6.  Create new DB
     
    `use newtestdb`
    
    `db.movie.insert({"name":"rajendra"})`
     
    `show dbs`

7.  Login into another mongo EC2 node
   
8.  Exec into container and access mongo console
     
    `docker exec -it mongonode /bin/bash`
     
    `mongo`

9.  Execute below commands on another nodes
     
    `rs.status()`
     
    `rs.slaveOk()` or try `secondaryOk()`

10. List the DB's on another nodes
     
    `show dbs`
