# README

If you don't have Ruby and Rails installed in your machine, you can follow the steps below:

# Required

* [Docker Engine](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/install/)

To run the application do:

1-)

```
  docker-compose build
```

After you finish as useful images, you can run an application using the command below:

2-)

```
  docker-compose up
```

3-) To create the database, in other terminal run the command:

```
  docker-compose run web rake db:setup
```

The application can now be accessed by the host http://localhost:3000

## API Requests

run the Curl command:

Create Game (to start a new bowling game)

```
curl -d '{"user_name": "Lucas Lima"}' -H "Content-Type: application/json" -X POST http://localhost:3000/games

```

Create Pitch (input the number of pins knocked down by each ball)

```
 curl -d '{"pins_knocked_down": 10}' -H "Content-Type: application/json" -X POST http://localhost:3000/games/1/pitches


```

Show Game

```
 curl http://localhost:3000/games/2

```


## Tests

run the command:

```
  docker-compose run web rspec
```
