#!/bin/bash

#bundle install --path vendor/bundle

ps aux |grep jekyll |awk '{print $2}' | xargs kill -9
bundle exec jekyll serve