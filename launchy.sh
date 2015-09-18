#/bin/bash


AMI=ami-d5c5d1e5  # Amazon linux.
SECURITY_GROUP_NAME="dliggat-web-sg"
KEY_NAME=daveliggat-trinimbus
KEY_PATH="${HOME}/.ssh/${KEY_NAME}.pem"
USER_DATA="file://user-data.yml"
EC2_TAG="dliggat-load-balancing-exp"

INSTANCE=$(aws ec2 run-instances                    \
           --image-id ${AMI}                        \
           --count 1                                \
           --instance-type m3.medium                \
           --security-groups ${SECURITY_GROUP_NAME} \
           --key-name ${KEY_NAME}                   \
           --user-data ${USER_DATA} | jq -r '.Instances[0].InstanceId')

echo "Instance: ${INSTANCE}"
echo 'sleeping for a bit...'
sleep 10

echo "Tagging with: ${EC2_TAG}"
aws ec2 create-tags --resources ${INSTANCE} --tags Key=Name,Value=${EC2_TAG}

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
echo ${PUBLIC_IP}
echo "ssh -i ${KEY_PATH} ec2-user@${PUBLIC_IP}"

# eval "function connect { ssh -v -i ${KEY_PATH} root@${PUBLIC_IP} }"

# eval "function delete { aws ec2 stop-instances --instance-ids ${INSTANCE} }"

# eval "function describe { aws ec2 describe-instances --instance-ids ${INSTANCE} }"












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
