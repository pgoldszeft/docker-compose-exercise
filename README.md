# Exercise docker-compose

We implemented a service that when requested it returns the ID of the server that responded.

The idea is to have an application that on boot calculates its ID.  
The application can run in several replicas and should run behind a load balancer.

## We use:
1. `nginx` for the load balancing
2. `redis` - every instance of the application increments a counter which value becomes its ID.
3. `docker-compose` for the deployment.
4. `flask` for the implementation of the web service in Python
5. `gunicorn` for running the web service under `wsgi`.

## How to run
```shell
docker-compose up --scale app=<number of replicas>
```

If the `--scale` option is not provided only one replica of the application will be launched.

## How do scale down
```shell
docker-compose down --remove-orphans
```

## To stop the containers without removing them (pause) 
```shell
docker-compose down
```

## To test the application querying the load balancer

Run the application as explained above and execute

```shell
curl http://0.0.0.0:4000
```

The result will be the number of the application instance that replied.  
We should obtain different results by repeating the query.

## To test the application by querying the specific instance

Run the following command:
```shell
❯ docker-compose ps -a
```
The result should return something like follows:
```
NAME                     IMAGE                COMMAND                                                          SERVICE   CREATED          STATUS          PORTS
docker-compose-app-1     docker-compose-app   "/usr/bin/dumb-init -- poetry run gunicorn -b 0.0.0.0 app:app"   app       12 seconds ago   Up 11 seconds   0.0.0.0:62117->8000/tcp
docker-compose-app-2     docker-compose-app   "/usr/bin/dumb-init -- poetry run gunicorn -b 0.0.0.0 app:app"   app       12 seconds ago   Up 10 seconds   0.0.0.0:62119->8000/tcp
docker-compose-app-3     docker-compose-app   "/usr/bin/dumb-init -- poetry run gunicorn -b 0.0.0.0 app:app"   app       12 seconds ago   Up 10 seconds   0.0.0.0:62120->8000/tcp
docker-compose-app-4     docker-compose-app   "/usr/bin/dumb-init -- poetry run gunicorn -b 0.0.0.0 app:app"   app       12 seconds ago   Up 11 seconds   0.0.0.0:62116->8000/tcp
docker-compose-nginx-1   nginx:latest         "/docker-entrypoint.sh nginx -g 'daemon off;'"                   nginx     12 seconds ago   Up 10 seconds   80/tcp, 0.0.0.0:4000->4000/tcp
docker-compose-redis-1   redis:4              "docker-entrypoint.sh redis-server"                              redis     12 seconds ago   Up 11 seconds   6379/tcp
```

The column `PORTS` shows the actual hostname and port of each instance.
To query one of them run the following:

```shell
curl http://0.0.0.0:62117
```

The answer is the ID of the service.  Repeating the command should not change the result.
