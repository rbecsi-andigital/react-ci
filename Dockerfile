FROM node:carbon-alpine

WORKDIR ./app

COPY . .

RUN yarn install

RUN yarn build

EXPOSE 5000
