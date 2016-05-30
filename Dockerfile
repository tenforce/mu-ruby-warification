FROM andreptb/oracle-java:7
# based on docker-jruby

ENV JRUBY_VERSION 9.0.5.0
ENV JRUBY_SHA256 9ef392bd859690c9a838f6475040345e0c512f7fcc0b37c809a91cf671f5daf3
RUN mkdir /opt/jruby \
  && curl -fSL https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VERSION}/jruby-bin-${JRUBY_VERSION}.tar.gz -o /tmp/jruby.tar.gz \
  && echo "$JRUBY_SHA256 /tmp/jruby.tar.gz" | sha256sum -c - \
  && tar -zx --strip-components=1 -f /tmp/jruby.tar.gz -C /opt/jruby \
  && rm /tmp/jruby.tar.gz \
  && ln -s /opt/jruby/bin/jruby /usr/local/bin/ruby
ENV PATH /opt/jruby/bin:$PATH

# skip installing gem documentation
RUN mkdir -p /opt/jruby/etc \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /opt/jruby/etc/gemrc

RUN gem install bundler

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

MAINTAINER Niels Vandekeybus <progster@gmail.com>
ADD . /build
WORKDIR /build
RUN mkdir -p /build/lib/ext && mkdir -p /build/lib/sinatra_template && gem install bundler && gem install warbler -v 2.0.0
CMD "./build.sh"


