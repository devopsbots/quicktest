docker build -t jzhao5/multi-client:latest jzhao5/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t jzhao5/multi-api:latest jzhao5/multi-api:$SHA -f ./server/Dockerfile ./server
docker build -t jzhao5/multi-worker:latest jzhao5/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push jzhao5/multi-client:latest
docker push jzhao5/multi-api:latest
docker push jzhao5/multi-worker:latest

docker push jzhao5/multi-client:$SHA
docker push jzhao5/multi-api:$SHA
docker push jzhao5/multi-worker:$SHA

kubectl apply -f k8s --namespace=multi-k8s

kubectl set image deployments/client-deployment client=jzhao5/multi-client:$SHA
kubectl set image deployments/api-deployment server=jzhao5/multi-api:$SHA
kubectl set image deployments/worker-deployment worker=jzhao5/multi-worker:$SHA