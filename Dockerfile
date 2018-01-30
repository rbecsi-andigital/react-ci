FROM node:carbon-alpine

WORKDIR ./app

COPY . .

RUN yarn install

RUN yarn build

RUN yarn serve

EXPOSE 5000
