from ruby:2.7.2

WORKDIR /app

COPY . ./
RUN ls

ENTRYPOINT [ "ruby" ]
CMD ["main.rb"]