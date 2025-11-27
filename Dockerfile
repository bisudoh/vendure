FROM node:22

WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm install -g lerna && npm install --production

COPY . .

RUN lerna bootstrap

RUN npm run build

CMD ["npm", "start"]
