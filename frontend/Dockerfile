FROM node:12.2.0-alpine 
WORKDIR /app
EXPOSE 8080
COPY package.json /app/package.json
RUN npm install --silent
COPY . .
CMD [ "npm", "run", "serve" ]
