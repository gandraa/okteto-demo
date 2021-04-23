FROM golang:alpine as builder
RUN apk --update --no-cache add bash
WORKDIR /app
ADD . .
RUN go build -o app

FROM alpine as prod
WORKDIR /app

### Setup user for build execution and application runtime
ENV APP_ROOT=/app
ENV PATH=${APP_ROOT}/app:${PATH} HOME=${APP_ROOT}
COPY --from=builder /app/app /app/app
RUN chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

### Containers should NOT run as root user
USER 1002340000
WORKDIR ${APP_ROOT}

EXPOSE 8080
CMD ["./app"]