FROM node:12.2.0-alpine
WORKDIR /app
COPY contracts/ .
RUN npm install --save-dev truffle
RUN npx truffle init
RUN npm install --save-dev @openzeppelin/contracts
RUN npm install --save-dev ganache-cli 
RUN npm install --save-dev chai
RUN npm install --save-dev @openzeppelin/test-helpers 
RUN npx truffle compile
EXPOSE 8545
COPY truffle-config.js .
COPY wrapper-script.sh .
RUN apk add --no-cache --upgrade bash
RUN chmod u+x wrapper-script.sh
CMD ./wrapper-script.sh
