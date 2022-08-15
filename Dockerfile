FROM ruby:3.1.2

EXPOSE 3000

WORKDIR /myapp
COPY . /myapp
RUN gem install bundler
RUN bundle install

CMD ["rails", "server", "-b", "0.0.0.0"]
