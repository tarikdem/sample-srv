FROM node:12.21-alpine as builder

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:12.21-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 3000
CMD ["npm", "run", "start:prod"]
