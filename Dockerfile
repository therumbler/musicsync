FROM ruby:2.7.2

WORKDIR /app

COPY . ./

ENTRYPOINT [ "ruby" ]
CMD ["main.rb"]