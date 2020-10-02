FROM node:14

RUN npm install -g "@angular/cli"

WORKDIR /app
ADD package*.json ./
RUN npm install
EXPOSE 4200

CMD ["ng", "serve", "--host", "0.0.0.0"]
