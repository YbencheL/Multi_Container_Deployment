FROM node:26-bookworm

COPY . /usr/src/app/API/

WORKDIR /usr/src/app/API

RUN apt update && apt install -y curl

RUN npm ci --omit=dev && npm install

EXPOSE 3000

CMD ["node", "server.js"]