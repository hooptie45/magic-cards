FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev bash git ack gawk
VOLUME /app
WORKDIR /app
COPY Gemfile Gemfile.lock ./
LABEL maintainer="Shaun <nanarpuss@gmail.com>"
RUN bundle install --path /app/vendor/bundle -j 8
CMD bash

