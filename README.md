The zoozle app is a real-time suggestions solution for search systems. The app's goal is not properly search something and show results, it's just give suggestions according to what have been searched on the platform.

Basically the suggestions and their matching sentences variations are handled by Redis. This way, we have a more faster response time on the search input autocomplete engine.

Also, the app looks for the trending searches, displaying them ordered by their popularity.

### Dependencies

* Ruby 2.3.4
* Rails 5.0.6

### Instalation

```sh
$ cd zoozle
$ bundle install
```

### Running

First, create your database.yml from scratch or use our sample:
```sh
$ cp config/database.yml.sample config/database.yml
```

Before run your app, you must create the dbs and apply the app's migrations:
```sh
$ cd microblog_api
$ rake db:create
$ rake db:migrate
```

To run the server, you'll need to use the gem [foreman](https://github.com/ddollar/foreman). Install it and then you can run the server with the default Procfile configuration:

Now, you can start the server:
```sh
$ foreman start
```

## Environments
The zoozle app requires the configuration of a few env vars, depending on the environment.

### Development
This process is optional for the development environment. If you want to modify the server's port(5000 by default), you must create a file called `.env` on the project's root path and define the following var:
```sh
PORT=3000
```

### Production
For the production environment(on the platform which your app was deployed), you must define the var that points to the redis db:
```sh
REDIS_URL={redis url here}
```
That's it! ;)
