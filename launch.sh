#/bin/bash

# Update the variables appropriately and source this file.



AMI=ami-3b6c620b    # ssg-trunk-07-29-2015-at-05-46-41
KEY_NAME=triautoUSWest2
KEY_PATH="deploy-portal-aws/etc/${KEY_NAME}.pem"
USER_DATA="file://dave-user-data.txt"
BLOCK=$(ruby -e "require 'json'; obj = JSON.parse(IO.read 'dave-ebs.json'); puts JSON.generate obj")

INSTANCE=$(aws ec2 run-instances \
           --image-id ${AMI} \
           --count 1 \
           --instance-type m3.medium \
           --key-name ${KEY_NAME} \
           --block-device-mappings ${BLOCK} \
           --user-data ${USER_DATA} | jq -r '.Instances[0].InstanceId')

echo ${INSTANCE}
echo 'sleeping for a bit...'
sleep 10

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
echo ${PUBLIC_IP}

eval "function connect { ssh -v -i ${KEY_PATH} root@${PUBLIC_IP} }"

eval "function delete { aws ec2 stop-instances --instance-ids ${INSTANCE} }"

eval "function describe { aws ec2 describe-instances --instance-ids ${INSTANCE} }"












# AMI=ami-e7527ed7  # amazon linux
# AMI=ami-4dbf9e7d  # RHEL
# BLOCK="[{\"DeviceName\":\"/dev/sdc\",\"Ebs\":{\"SnapshotId\":\"snap-6399943f\",\"DeleteOnTermination\":true,\"VolumeType\":\"standard\"}}]"




# #/bin/bash

# INSTANCE=$(aws ec2 run-instances --image-id ami-e7527ed7 --count 1 --instance-type m3.medium --key-name triautoUSWest2  --user-data file://dave-user-data.txt | jq -r '.Instances[0].InstanceId')
# echo $INSTANCE
# echo 'sleeping for a bit...'
# sleep 10

# PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
# echo $PUBLIC_IP

# eval "function connect { ssh -v -i deploy-portal-aws/etc/triautoUSWest2.pem ec2-user@$PUBLIC_IP }"

# eval "function delete { aws ec2 stop-instances --instance-ids $INSTANCE }"

#eval "function describe { aws ec2 describe-instances --instance-ids $INSTANCE }"





# aws ec2 authorize-security-group-ingress --group-id sg-43e4ee21 --protocol tcp --port 22 --cidr 0.0.0.0/0
# aws ec2 stop-instances --instance-ids i-6e6ff7a6
