#!/usr/bin/python3
import boto3

def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    regions = [region['RegionName']
        for region in ec2_client.describe_regions()['Regions']]
    
    for region in regions:
        ec2 = boto3.resource('ec2', region_name=region)
        print("Region: ", region)
        #Get only running instances
        instances = ec2.instances.filter(
            Filters=[
                {
                    'Name': 'instance-state-name',
                    'Values':[
                        'running'
                    ]
                }
            ],
            DryRun=False
        )
        for instance in instances:
            instance.stop()
            print('Stopped instance: ', instance.tags[0]['Value'])

