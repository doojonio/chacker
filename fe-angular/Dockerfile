FROM node:14

RUN npm install -g "@angular/cli"

WORKDIR /app
ADD package*.json ./
RUN npm install
EXPOSE 4200

ADD . /app

ENTRYPOINT ["/usr/local/bin/ng"]
