FROM ruby:2.6.6

RUN gem install bundler
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN bundle install --deployment --without development test

EXPOSE 3000

COPY . .

RUN SECRET_ENV_VAR=$(bundle exec rails secret) &&\
    echo -e "production:\n  secret_key_base:" > ./config/.example_secrets.yml &&\
    echo "$(cat ./config/.example_secrets.yml) $SECRET_ENV_VAR" > ./config/secrets.yml

RUN echo -e "DB_USERNAME='root'\nDB_PASSWORD='postgres'\nDB_HOST='ptistool-db'\nCORS_ORIGINS='*'" > .env
