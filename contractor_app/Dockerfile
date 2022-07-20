FROM ruby:3.1
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# COPY Procfile /app/Procfile
# RUN gem install foreman

RUN wget https://github.com/DarthSim/hivemind/releases/download/v1.1.0/hivemind-v1.1.0-linux-amd64.gz \
  && gunzip hivemind-v1.1.0-linux-amd64.gz \
  && chmod +x hivemind-v1.1.0-linux-amd64 \
  && mv hivemind-v1.1.0-linux-amd64 /usr/bin/hivemind

COPY wait-for-it.sh /usr/bin/
RUN chmod +x /usr/bin/wait-for-it.sh

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["wait-for-it.sh", "rabbitmq:5672", "-t", "60", "--", "hivemind"]