FROM jruby:1.7
MAINTAINER Niels Vandekeybus <progster@gmail.com>
ADD . /build
WORKDIR /build
RUN gem install bundler && gem install warbler
CMD "./build.sh"


