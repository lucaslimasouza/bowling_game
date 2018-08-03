FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /bowling_game
WORKDIR /bowling_game
COPY Gemfile /bowling_game/Gemfile
COPY Gemfile.lock /bowling_game/Gemfile.lock
RUN bundle install
COPY . /bowling_game
