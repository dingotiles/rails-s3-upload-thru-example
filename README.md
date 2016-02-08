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

Create AWS S3 & postgresql service instances:

```
cf create-service
cf create-service
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
  - rails-s3-upload-thru-example-pg
  - rails-s3-upload-thru-example-s3
```

To deploy the application and run the database migrations:

```
cf push
cf ssh rails-s3-upload-thru-example -c '/tmp/lifecycle/launcher "app" "rake db:migrate" ""'
```

The last line is to run `rake db:migrate` to create/upgrade the postgresql database schema. See https://blog.starkandwayne.com/2016/02/07/run-one-off-tasks-and-database-migrations/ for why the `cf ssh` command looks ungamely at the moment.
