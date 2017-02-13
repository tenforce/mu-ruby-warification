#!/bin/bash

set -e

rm -fR /app/target
mkdir -p /app/target/app/ext
cp -R /warification/app /app/target/
cp -R /opt/mu-ruby-template-${MU_RUBY_TEMPLATE_VERSION:1}/{lib,sinatra_template,web.rb} /app/target/app/
cp -R `find * -maxdepth 0 -not -name target` /app/target/app/ext/

cp -R /warification/{Gemfile,config.ru,config} /app/target/
echo "gem 'rjack-logback'" >> /app/target/Gemfile
ln -s app/ext /app/target/

(cd /app/target && bundle install --without development test && warble executable war)
