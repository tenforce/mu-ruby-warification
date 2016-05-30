#!/bin/bash

# retrieve template files
TEMPLATE=`grep semtech/mu-ruby-template  /package/Dockerfile | awk '{split($0,a,":"); print a[2]}' |  tr -d '[:blank:]'`
wget "https://raw.githubusercontent.com/mu-semtech/mu-ruby-template/v$TEMPLATE/Gemfile" -O /build/Gemfile
wget "https://raw.githubusercontent.com/mu-semtech/mu-ruby-template/v$TEMPLATE/sinatra_template/helpers.rb" -O /build/lib/sinatra_template/helpers.rb
# remove eval/include lines (assumes these are the last 3 lines, dangerous)
sed -i '$ d' /build/Gemfile
sed -i '$ d' /build/Gemfile
sed -i '$ d' /build/Gemfile

# merge gemfiles
cat /package/Gemfile >> /build/Gemfile
echo "" >> /build/Gemfile
echo "gem 'rjack-logback'" >> /build/Gemfile
echo "gem 'psych'" >> /build/Gemfile

# merge entrypoint
ENTRYPOINT=`grep APP_ENTRYPOINT  /package/Dockerfile | awk '{split($0,a," "); print a[3]}'`
ENTRYPOINT=${ENTRYPOINT:="web.rb"}

sed -i "s/#{app_file}/$ENTRYPOINT/" lib/web.rb
sed -i "s/CONFIG_DIR_VAR/$CONFIG_DIR/" lib/web.rb
# copy other yml and ruby files if they exist
FILES=`find /package -iname "*.rb" -o -iname "*.yml" -o -iname "*.xsd" -o -iname "*.wsdl"`
for file in $FILES;do
  FILEDIR=`dirname $file | sed 's|/package||'`
  echo $FILEDIR
  if [[ ! -d /build/lib/ext/$FILEDIR ]]; then
			mkdir /build/lib/ext/$FILEDIR
  fi
  cp $file /build/lib/ext/$FILEDIR
done
# package it up
cd /build && bundle install && warble war && mv *war /package/
