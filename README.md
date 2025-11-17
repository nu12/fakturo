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

## Using docker/podman

Build a new image:

```
podman build -t fakturo .
``` 

Run the image:

```
podman run --rm --name fakturo -e SECRET_KEY_BASE=<MASTER-KEY> -e RAILS_ENV=test -p 3000:3000 fakturo ./bin/rails server
``` 

## Release a new version

Change the version in `config/application` and run `git tag $(bundle exec rake version | tr -d '"') && git push --tags`.