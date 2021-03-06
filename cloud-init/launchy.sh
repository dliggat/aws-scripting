#/bin/bash


if [[ "${UBUNTU:-false}" = "true" ]]; then
  echo "Using Ubuntu"
  AMI=ami-5189a661  # Ubuntu.
  SSHUSER=ubuntu
  USER_DATA="file://ubuntu.yml"
else
  echo "Using Amazon Linux"
  AMI=ami-d5c5d1e5  # Amazon linux.
  SSHUSER=ec2-user
  USER_DATA="file://amazon-linux.yml"
fi

SECURITY_GROUP_NAME="dliggat-web-sg"     # HTTP/HTTPS/SSH ingress.
KEY_NAME=daveliggat-trinimbus
KEY_PATH="${HOME}/.ssh/${KEY_NAME}.pem"

EC2_TAG="${EC2_TAG:-dliggat}"
INSTANCE_COUNT="${INSTANCE_COUNT:-1}"
SLEEP_TIME=15
INSTANCE_TYPE=m3.medium

INSTANCE=$(aws ec2 run-instances                      \
             --image-id ${AMI}                        \
             --count ${INSTANCE_COUNT}                \
             --instance-type ${INSTANCE_TYPE}         \
             --security-groups ${SECURITY_GROUP_NAME} \
             --key-name ${KEY_NAME}                   \
             --user-data ${USER_DATA} | jq -r '.Instances[0].InstanceId')

echo "Instance: ${INSTANCE}"
echo "Sleeping for ${SLEEP_TIME} seconds..."
sleep ${SLEEP_TIME}

echo "Tagging with: ${EC2_TAG}"
aws ec2 create-tags --resources ${INSTANCE} --tags Key=Name,Value=${EC2_TAG}

PUBLIC_IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE} | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
echo ${PUBLIC_IP}
echo "ssh -i ${KEY_PATH} ${SSHUSER}@${PUBLIC_IP}"

# eval "function connect { ssh -v -i ${KEY_PATH} root@${PUBLIC_IP} }"
# eval "function delete { aws ec2 stop-instances --instance-ids ${INSTANCE} }"
# eval "function describe { aws ec2 describe-instances --instance-ids ${INSTANCE} }"
