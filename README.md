# Rails app to upload files to AWS S3 on Cloud Foundry


### Local development

Setup environment variables:

```bash
```

Run application:

```
bundle
./bin/rails s
```

Launch browser http://localhost:3000

### Deploy to Cloud Foundry

Create AWS S3 & postgresql/mysql service instances:

```
cf create-service <pg|mysql> <plan> rails-s3-upload-thru-example-sql
cf create-service <aws-s3> <plan> rails-s3-upload-thru-example-s3
```

The default `manifest.yml` will bind the application to these service instances:

```yaml
---
applications:
- name: rails-s3-upload-thru-example
  memory: 256M
  instances: 1
  buildpack: ruby_buildpack
  services:
  - rails-s3-upload-thru-example-sql
  - rails-s3-upload-thru-example-s3
```

To deploy the application and run the database migrations:

```
cf push
cf ssh rails-s3-upload-thru-example -c '/tmp/lifecycle/launcher "app" "rake db:migrate" ""'
```

The last line is to run `rake db:migrate` to create/upgrade the postgresql database schema. See https://blog.starkandwayne.com/2016/02/07/run-one-off-tasks-and-database-migrations/ for why the `cf ssh` command looks ungamely at the moment.
