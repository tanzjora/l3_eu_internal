#!/bin/python
#This script uses two lists to print out information for instances in AWS by entering only the instanceID in a file called "list.txt", which has to be in the same directory as the script.
#the second list is build in the script and it contains regions in which you are looking for the instance. You can modify it if you need to search in additional regions than the ones that
#are currently contained in the script. Instances should be one per line in the "list.txt" file!
import boto3

instances_list = []
regions = ['eu-west-1', 'eu-central-1', 'ap-southeast-1', 'ap-northeast-1', 'us-east-1', 'ap-southeast-2']

with open('list.txt') as instances:
    for line in instances:
        instances_list.append(line.strip())


def get_priv_dns_name(instances_l, regions):
    for node in instances_list:
        for region in regions:
                ec2=boto3.client('ec2', region_name=region)
                try:
                    instance_dns = ec2.describe_instances(InstanceIds=[node])['Reservations'][0]['Instances'][0]['PrivateDnsName']
                    print(node + " "  + instance_dns + " " + region)
                    break
                except:
                    pass

### MAIN ###
get_priv_dns_name(instances_list, regions)
