FROM ruby:2.2
MAINTAINER Dave Nunez <dnunez24@gmail.com>

ENV RACK_ENV development
RUN mkdir -p /srv/www/app
WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
COPY . /srv/www/app
WORKDIR /srv/www/app

EXPOSE 9292
VOLUME /srv/www/app
CMD foreman start
