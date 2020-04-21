# build our images
docker build -t faustaleonardo/multi-client:latest -t faustaleonardo/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t faustaleonardo/multi-server:latest -t faustaleonardo/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t faustaleonardo/multi-worker:latest -t faustaleonardo/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# push to docker hub
docker push faustaleonardo/multi-client:latest
docker push faustaleonardo/multi-client:$SHA

docker push faustaleonardo/multi-server:latest
docker push faustaleonardo/multi-server:$SHA

docker push faustaleonardo/multi-worker:latest
docker push faustaleonardo/multi-worker:$SHA

# apply our config files
kubectl apply -f ./k8s

# set separate image for deployment
kubectl set image deployments/server-deployment server=faustaleonardo/multi-server:$SHA
kubectl set image deployments/client-deployment client=faustaleonardo/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=faustaleonardo/multi-worker:$SHA

