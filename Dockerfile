FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs
RUN mkdir /nomikai-app
WORKDIR /nomikai-app
COPY Gemfile /nomikai-app/Gemfile
COPY Gemfile.lock /nomikai-app/Gemfile.lock
RUN bundle install
COPY . /nomikai-app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]