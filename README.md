Mu Ruby Warification
====================

This is a Docker image that build any micro-service based on mu-ruby-template
and generate a generic WAR file that includes Jetty.

Usage
-----

```
docker run -it --rm \
    -v <ABSOLUTE_PATH_TO_YOUR_APP>:/app \
    -e SERVICE_NAME=<YOUR_APP_NAME> \
    tenforce/mu-ruby-warification
```

The `target.war` should be found in the directory target of your application.

**Note:** you can cache the gem files downloaded by putting `/root/.gem` in a
Docker volume:

```
    -v gem:/root/.gem \
```
