# Stage 1
FROM python:3.11-slim as base

ENV PYTHONUNBUFFERED 1

RUN apt-get update

ADD requirements.txt /app/requirements.txt
RUN pip install -r /app/requirements.txt

ADD . /app
WORKDIR /app

ARG BUILD_DATE
ARG REVISION
ARG VERSION

LABEL created $BUILD_DATE
LABEL version $VERSION
LABEL revision $REVISION

LABEL vendor "Democracia en Red & Reflejar"
LABEL title "Pesticidas introducidos silenciosamente"

EXPOSE 8050

CMD [ "gunicorn", "main:app.server", "--bind", "0.0.0.0:8050", "--chdir=/app", "--timeout", "1800" ]