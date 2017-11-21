FROM node:8-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache git 

WORKDIR /srv/app
ADD . /srv/app

RUN yarn install && \
    yarn cache clean

EXPOSE 3000

CMD [ "yarn", "start" ]
