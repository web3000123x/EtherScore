FROM tiangolo/uvicorn-gunicorn:python3.8-alpine3.10
RUN apk add --update build-base
COPY requirements.txt ./requirements.txt
RUN pip install --pre gql[requests]
RUN pip install -r requirements.txt
COPY ./app /app