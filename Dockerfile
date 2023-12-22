FROM python:3.11-slim

RUN apt-get update --no-install-recommends && \
    apt-get install --no-install-recommends -y dumb-init

RUN pip install poetry==1.2.2

RUN mkdir -p /srv/app
RUN useradd --uid 1337 -s /bin/bash -d /srv/app pablo
RUN chown -R pablo:pablo /srv/app
USER pablo
WORKDIR /srv/app
ADD --chown=pablo:pablo . /srv/app/

RUN cd /srv/app && poetry install

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
EXPOSE 8000
