FROM nginx:1.19.10-alpine

RUN rm /etc/nginx/conf.d/default.conf
RUN mkdir /etc/nginx/templates
COPY dev.conf.template /etc/nginx/templates
