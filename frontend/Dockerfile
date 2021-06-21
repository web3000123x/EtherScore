FROM node:12.2.0-alpine 
WORKDIR /app
EXPOSE 8080
COPY package.json ./
RUN npm install
CMD [ "npm", "run", "serve" ]
