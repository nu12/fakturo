# Fakturo

Fakturo is a tool to help you organize your finances. Visualize where your money is spent and take control over your budget.

Knowledge is power.

## Development

Install gems:

```
bundle install
```

Create the database, migrate and seed for local developpment:

```
rails db:create && rails db:prepare
```

Run the application locally:

```
rails s -b 0.0.0.0
```

Access `localhost:3000`.

### Upload processing (optional)

Uploaded files are processed asynchronously by ActiveJob.perform_later calls, using a RabbitMQ server for RPC. The instructions bellow will setup the development environment to do so. 

Start the RabbitMQ server with the following command:

```
podman run -d --hostname localhost --name rabbitmq -p 5672:5672 rabbitmq:3
```

Start ActiveJob queue processing with the following command in a separated terminal after starting the application:

```
bin/jobs
```

Note: `ghostscript` and `imagemagick` must be installed.

#### RPC server (examples in /vendor)

The RPC server connected to the RabbitMQ is responsible for processing the content of uploaded files. As this tend to be very specific and difficult to predict, it was left out of the scope of the project. If you decide to deploy this project and wants to take advantage of this feature, you are required to provide your own implementation of the RPC server.

To guide developments in this area, the folder `/vendor` contains examples that can be used to bootstrap a custom solution.

#### RabbitMQ authentication

As of gem `bunny` version `~> 2.24`, the `RABBITMQ_URL` environment variable can be used to [configure authentication and other connection parameters](https://github.com/ruby-amqp/bunny/blob/main/docs/guides/connecting.md#the-rabbitmq_url-environment-variable).

### Using docker/podman

Build a new image:

```
podman build -t fakturo .
``` 

Run the image:

```
podman run --rm --name fakturo -e SECRET_KEY_BASE=<MASTER-KEY> -e RAILS_ENV=development -p 3000:3000 fakturo ./bin/rails server
``` 

## Production

### Helm

A secret with the keys for rails and lockbox is needed, but is not managed by the chart. Create the secret manually with the following command:

```
cat <<EOF | kubectl apply -n fakturo -f -
apiVersion: v1
kind: Secret
metadata:
  name: master-keys
type: Opaque
data:
  rails: cGxhY2Vob2xkZXIK
  lockbox: cGxhY2Vob2xkZXIK
EOF
```

To deploy the chart:

```
helm upgrade --install fakturo helm/ -n fakturo
```

### TLS with Gateway Api

When creating a HTTPS endpoint via the Kubernetes Gateway API, a secret with the certificate and key is needed. Create it with the following command:

```
cat <<EOF | kubectl apply -n fakturo -f -
apiVersion: v1
kind: Secret
metadata:
  name: fakturo-tls
type: Opaque
data:
  tls.crt: cGxhY2Vob2xkZXIK
  tls.key: cGxhY2Vob2xkZXIK
EOF
```

### RabbitMQ Authentication

To authenticate to a RabbitMQ server in production, first create the user and password in the RabbitMQ container:

```
rabbitmqctl add_user 'username' 'password'
```

Grant permissions to the virtual host be to user (also in the RabbitMQ container):

```
rabbitmqctl set_permissions -p "/" "username" ".*" ".*" ".*"
```

Create the secret with the connection string and :

```
cat <<EOF | kubectl apply -n fakturo -f -
apiVersion: v1
kind: Secret
metadata:
  name: fakturo-rabbitmq
type: Opaque
data:
  connection_string: YW1xcDovL1VTRVJOQU1FOlBBU1NXT1JEQHJhYmJpdG1x
EOF
```

Then, use the secret to create the RABBITMQ_URL environment variable:

```
env:        
- name: RABBITMQ_URL
  valueFrom:
    secretKeyRef:
      name: fakturo-rabbitmq
      key: connection_string
```

## Release a new version

Change the version in `config/application` and run `git tag $(bundle exec rake version | tr -d '"') && git push --tags`.