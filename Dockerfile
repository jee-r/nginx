FROM nginxinc/nginx-unprivileged:alpine
LABEL maintainer="Jee"

ARG GID=${GID:-1000}
ARG GROUP_NAME=${GROUP_NAME:-php}

USER root

RUN sed -i 's/http:\/\/dl-cdn.alpinelinux.org/https:\/\/mirrors.ircam.fr\/pub/' /etc/apk/repositories && \
    apk update && \
    apk upgrade && \
    apk --no-cache add shadow && \
    echo "Add Group ${GROUP_NAME} with gid ${GID}" && \
    if [ "$(grep ':'${GID}':' /etc/group)" == "" ]; then \
      addgroup -g ${GID} ${GROUP_NAME}; \
    else \
      GROUP_NAME=$(grep ':'${GID}':' /etc/group | cut -d: -f1); \
    fi && \
    usermod -a -G ${GID} nginx

USER 101
COPY ./default.conf /etc/nginx/conf.d/default.conf
