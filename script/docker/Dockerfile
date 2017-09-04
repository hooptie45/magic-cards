FROM ruby:2.4-alpine

RUN apk update && apk add build-base nodejs postgresql-dev bash
VOLUME /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./

LABEL maintainer="Nick Janetakis <nick.janetakis@gmail.com>"

CMD bash

