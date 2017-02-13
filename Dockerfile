FROM java:7-jre

LABEL authors="Niels Vandekeybus <progster@gmail.com>, Cecile Tonglet <cecile.tonglet@tenforce.com>"

ENV MU_RUBY_TEMPLATE_VERSION=v2.3.0-ruby2.3
ENV JRUBY_VERSION 9.0.5.0
ENV WARBLER_VERSION 2.0.0

# NOTE: the latest known version to be working is 9.1.5.0. The version 9.1.6.0
#       is known to be breaking: when multiple WAR files are generated with
#       that version are being loaded on WebLogic, the first WAR loads properly
#       and all the others fail with:
# java.lang.NoClassDefFoundError: Could not initialize class org.jruby.runtime.scope.ManyVarsDynamicScope
RUN mkdir /opt/jruby \
	&& curl -fSL https://s3.amazonaws.com/jruby.org/downloads/${JRUBY_VERSION}/jruby-bin-${JRUBY_VERSION}.tar.gz -o /tmp/jruby.tar.gz \
	&& tar -zx --strip-components=1 -f /tmp/jruby.tar.gz -C /opt/jruby \
	&& rm /tmp/jruby.tar.gz \
	&& ln -s /opt/jruby/bin/jruby /usr/local/bin/ruby
ENV PATH /opt/jruby/bin:$PATH

# skip installing gem documentation
COPY gemrc /opt/jruby/etc/gemrc

RUN gem install bundler

# install things globally, for great justice
# and don't create ".bundle" in all our apps

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p -m 777 "$GEM_HOME" "$BUNDLE_BIN"

# NOTE: enforces the JRuby packaged in the WARs to be the same version than the
#       one installed here
RUN gem install jruby-jars -v $JRUBY_VERSION
RUN gem install warbler -v $WARBLER_VERSION

RUN curl -fSL https://github.com/mu-semtech/mu-ruby-template/archive/$MU_RUBY_TEMPLATE_VERSION.tar.gz | tar -zx -C /opt

ADD . /warification

WORKDIR /app

VOLUME /root/.m2
VOLUME /root/.gem

CMD ["/warification/warify.sh"]
