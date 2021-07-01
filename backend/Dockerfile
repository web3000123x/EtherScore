FROM tiangolo/uvicorn-gunicorn:python3.8-alpine3.10
RUN apk add --update build-base git
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt
RUN git clone https://github.com/eouti/covalent_py
RUN cd covalent_py/ && python setup.py build && python setup.py install
COPY ./app /app