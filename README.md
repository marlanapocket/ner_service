
# NER Service

This is an API to process pages with NER recognition.

## Deployment
### First steps
The application runs on Ruby 3.0.1. You can install it using rvm (or rbenv, or any other way).
```bash
  rvm install "ruby-3.0.1"
```
All dependencies of the project can then be installed using bundler
```bash
  bundle install
```
### Setting up the database
You can use a standalone database or use docker for this.
Create a docker container and create an empty database named "newspapers"
```bash
docker run --name ner_service_database -e POSTGRES_PASSWORD=secret -p 127.0.0.1:5433:5432 -d postgres
```
```bash
docker exec -it ner_service_database createdb -U postgres ner_service`
```
Modify the content of `config/database.yml` according to your configuration.

Launch migrations to effectively create the tables: `rails db:migrate`.
You can load some test data by executing `rails db:seed` (the associated file is `/app/db/seeds.rb`)

### Setting up Redis and Sidekiq
Redis is used by the Sidekiq gem to keep track of background jobs. You can use docker to install it.
```bash
docker run --name ner_service_redis -p 127.0.0.1:6379:6379 -d redis
```
To actually start the Sidekiq process, enter `bundle exec sidekiq` in a new terminal.
To start the web server, use `rails server`

## Usage
### Login
First you need to connect to the server using credentials. For this example, we'll use the user imported by executing the `rails db:seed` command.

`POST http://localhost:3000/login`
`Headers: [Content-Type: application/json]`
`data:`
```json
{
  "user": {
    "email":"test@test.com",
    "password":"test"
  }
}
```
This will return a 200 OK response with an Authorization header containing an access token for this session.
Every subsequent call to the API should include this token in an Authorization header.
### Training a new model
You can train a new model by making the following request.
`POST http://localhost:3000/train`
`Headers: [Content-Type: application/json, Authorization: Bearer x...x]`
`data: `
```json
{
  "files_urls": [
    "https://url.to.training_file#1",
    "https://url.to.training_file#2",
    "..."
  ], 
  "transkribus_user_id":"trnskrbs_1",
  "model_title": "MyNERModel",
  "model_description":"this is a great AI model !",
  "model_language":"fr"
}
```
### Analysing a set of pages
You can analyse a set of pages by issuing the following request.
`POST http://localhost:3000/recognize`
`Headers: [Content-Type: application/json, Authorization: Bearer x...x]`
`data: `
```json
{
  "files_urls": [
    "https://url.to.page_file#1",
    "https://url.to.page_file#2",
    "..."
  ],
  "transkribus_user_id":"trnskrbs_1",
  "model_id": 1
}
```
### Listing available models
You can get a list of the public models and the models you have previously trained using the following request.
`GET http://localhost:3000/list_models`
`Headers: [Content-Type: application/json, Authorization: Bearer x...x]`
### Listing the tasks associated with a user
You can get the tasks started by a specific user (the `transkribus_user_id` field in train and recognize functions).
`GET http://localhost:3000/list_tasks/<transkribus_user_id>`
`Headers: [Content-Type: application/json, Authorization: Bearer x...x]`
### Getting the status of a task
You can get the current status of a specific task by issuing the following request.
`GET http://localhost:3000/status/<task_id>`
`Headers: [Content-Type: application/json, Authorization: Bearer x...x]`