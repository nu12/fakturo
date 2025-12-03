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
rails db:create && rails db:migrate && rails db:seed
```

Run the application locally:

```
rails s -b 0.0.0.0
```

Access `localhost:3000`.

### Upload processing

Uploaded files are processed asynchronously by ActiveJob.perform_later calls, using a RabbitMQ server for RPC. The instructions bellow will setup the development environment to do so. 

Start the RabbitMQ server with the following command:

```
podman run -d --hostname localhost --name rabbitmq -p 5672:5672 rabbitmq:3
```

In a separated terminal, start the RPC server with the following commands:

```
cd vendor/gpt4all
source fakturo/bin/activate
pip install -r requiremets.txt
python main.py
```

Start ActiveJob queue processing with the following command in a separated terminal after starting the application:

```
bin/jobs
```

`ghostscript` must be installed.

## Using docker/podman

Build a new image:

```
podman build -t fakturo .
``` 

Run the image:

```
podman run --rm --name fakturo -e SECRET_KEY_BASE=<MASTER-KEY> -e RAILS_ENV=development -p 3000:3000 fakturo ./bin/rails server
``` 

## Release a new version

Change the version in `config/application` and run `git tag $(bundle exec rake version | tr -d '"') && git push --tags`.