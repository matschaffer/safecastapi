FROM ruby:2.1.10-onbuild

ENV RAILS_ENV docker

EXPOSE 3000

RUN apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

CMD bundle exec rails server
