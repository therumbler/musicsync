FROM ruby:2.7.2

WORKDIR /app

COPY . ./

EXPOSE 2345

ENTRYPOINT [ "ruby" ]
CMD ["main.rb"]