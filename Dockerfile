FROM node:carbon-alpine

WORKDIR ./app

COPY . .

RUN yarn install

RUN yarn build-css

RUN yarn build-js

EXPOSE 5000
