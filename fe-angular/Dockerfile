FROM node:14

RUN npm install -g "@angular/cli"

WORKDIR /app
EXPOSE 4200

ADD . /app

ENTRYPOINT ["/usr/local/bin/ng"]
