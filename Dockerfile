FROM ruby:3.1.2-bullseye as base

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev

WORKDIR /app

RUN gem install bundler -v 2.4.7

COPY Gemfile* ./

RUN bundle install

ADD . /app

EXPOSE 4000

CMD ["./bin/rails", "server"]
