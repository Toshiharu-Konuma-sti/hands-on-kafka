FROM apache/kafka:4.3.1

USER root

RUN apk add --no-cache python3 py3-pip && \
    pip3 install --quiet --break-system-packages kafka-python jsonschema requests

USER appuser
