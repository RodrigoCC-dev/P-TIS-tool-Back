FROM ruby:2.6.6

RUN gem install bundler -v '~>2.2.26'
RUN bundle config --global frozen 1

RUN apt-get update && apt-get install -y nano

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install --deployment --without development test

EXPOSE 8080

COPY . .

RUN SECRET_ENV_VAR=$(bundle exec rails secret) &&\
    echo "production:\n  secret_key_base:" > ./config/.example_secrets.yml &&\
    echo "$(cat ./config/.example_secrets.yml) $SECRET_ENV_VAR" > ./config/secrets.yml

RUN echo "DB_USERNAME='root'\nDB_PASSWORD='ptis2021'\nDB_HOST='database'\nCORS_ORIGINS='*'" > .env
