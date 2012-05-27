#!/bin/sh
bundle install
cp ./config/database.yml.mac ./config/database.yml -f
bundle exec rake db:Schema:load
bundle exec thin start
