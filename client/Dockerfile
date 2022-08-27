ARG IMAGE_VERSION

FROM nginx:${IMAGE_VERSION} as prod

EXPOSE 80

VOLUME [ "/etc/nginx/conf.d/certs" ]

ENV PROXY_PASS ''

COPY nginx.conf /nginx.template

CMD ["/bin/sh","-c", "envsubst '${PROXY_PASS} ${PROXY_SSL_VERIFY}' < /nginx.template > /etc/nginx/conf.d/default.conf; nginx-debug -g 'daemon off;'"]