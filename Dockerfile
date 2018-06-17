FROM alpine:3.7

RUN apk add --update --no-cache ca-certificates bash python jq \
    && python -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip install --upgrade --ignore-installed pip setuptools awscli \
    && rm -r /root/.cache

COPY sync /bin/

ENTRYPOINT ["/bin/bash"]

CMD ["/bin/sync"]
