FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

CMD script/server
