#!/bin/bash

# retrieve template files
TEMPLATE=`grep semtech/mu-sinatra-template  /package/Dockerfile | awk '{split($0,a,":"); print a[2]}'`
wget https://raw.githubusercontent.com/mu-semtech/mu-sinatra-template/v$TEMPLATE/Gemfile -O /build/Gemfile
wget https://raw.githubusercontent.com/mu-semtech/mu-sinatra-template/v$TEMPLATE/web.rb -O /build/lib/web.rb

# remove eval/include lines (assumes these are the last 3 lines, dangerous)
sed -i '$ d' /build/Gemfile
sed -i '$ d' /build/Gemfile
sed -i '$ d' /build/Gemfile

sed -i '$ d' /build/lib/web.rb
sed -i '$ d' /build/lib/web.rb

# merge gemfiles
cat /package/Gemfile >> /build/Gemfile

# merge entrypoint
ENTRYPOINT=`grep APP_ENTRYPOINT  /package/Dockerfile | awk '{split($0,a," "); print a[3]}'`
ENTRYPOINT=${ENTRYPOINT:="web.rb"}
cat /package/$ENTRYPOINT >> /build/lib/web.rb

# copy other yml and ruby files if they exist
FILES=`find /package -iname ".rb" -iname "*.yml" -wholename $ENTRYPOINT -prune`
for file in $FILES;do
  FILEDIR=`dirname $file`
  if [[ ! -d /build/lib/$FILEDIR ]]; then
			mkdir /build/lib/$FILEDIR
  fi
  cp $file /build/lib/$FILEDIR
done
# package it up
cd /build && bundle install && warble war && mv *war /package/
