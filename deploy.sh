docker build -t jzhao5/multi-client:latest jzhao5/multi-client2:$SHA -f ./client/Dockerfile ./client
docker build -t jzhao5/multi-api:latest jzhao5/multi-server2:$SHA -f ./server/Dockerfile ./server
docker build -t jzhao5/multi-worker:latest jzhao5/multi-worker2:$SHA -f ./worker/Dockerfile ./worker

docker push jzhao5/multi-client2:latest
docker push jzhao5/multi-server2:latest
docker push jzhao5/multi-worker2:latest

docker push jzhao5/multi-client2:$SHA
docker push jzhao5/multi-server2:$SHA
docker push jzhao5/multi-worker2:$SHA

export AWS_ACCESS_KEY_ID="$(echo ${CREDENTIALS} | jq -r '.Credentials.AccessKeyId')"
export AWS_SECRET_ACCESS_KEY="$(echo ${CREDENTIALS} | jq -r '.Credentials.SecretAccessKey')"
##export AWS_SESSION_TOKEN="$(echo ${CREDENTIALS} | jq -r '.Credentials.SessionToken')"
##export AWS_EXPIRATION=$(echo ${CREDENTIALS} | jq -r '.Credentials.Expiration')
aws eks update-kubeconfig --name $EKS_CLUSTER_NAME

kubectl apply -f k8s --namespace=multi-k8s

kubectl set image deployments/client-deployment client=jzhao5/multi-client2:$SHA
kubectl set image deployments/server-deployment server=jzhao5/multi-server2:$SHA
kubectl set image deployments/worker-deployment worker=jzhao5/multi-worker2:$SHA