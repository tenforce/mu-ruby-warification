# warify

A simple docker to create a war from a mu-semtech service that is based on mu-r-sinatra-template.

```bash
docker build -t warify .
docker run -v /path/to/the-git-repo:/package warify
``` 

This will build a war from the project and place it in the git repo path as build.war
