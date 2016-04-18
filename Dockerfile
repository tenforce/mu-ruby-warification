FROM jruby:1.7
MAINTAINER Niels Vandekeybus <progster@gmail.com>
ADD . /build
WORKDIR /build
RUN mkdir -p /build/lib/ext && mkdir -p /build/lib/sinatra_template && gem install bundler && gem install warbler
CMD "./build.sh"


