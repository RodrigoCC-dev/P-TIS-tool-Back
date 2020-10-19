FROM ruby:2.6.6

RUN gem install bundler
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install

EXPOSE 8080

CMD ["bundle", "exec", "passenger", "start"]

COPY . .
