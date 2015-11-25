FROM asakaguchi/ngx-mruby

ENV HUGO_VERSION 0.14

RUN apk --update add sudo curl expect rsync \
  && curl -SLO "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_linux_amd64.tar.gz" \
  && tar -xzf "hugo_${HUGO_VERSION}_linux_amd64.tar.gz" \
  && mv hugo_${HUGO_VERSION}_linux_amd64/hugo_0.14_linux_amd64 /usr/local/bin/hugo \
  && mkdir -m 775 /usr/local/src \
  && chgrp daemon /usr/local/src \
  && chgrp -R daemon /usr/share/nginx/html \
  && chmod -R 775 /usr/share/nginx/html \
  && apk del curl \
  && rm -rf hugo_${HUGO_VERSION}_linux_amd64.tar.gz \
            hugo_${HUGO_VERSION}_linux_amd64 \
            /var/cache/apk/*

COPY update-site.sh /usr/local/bin/update-site.sh
COPY startup.sh /usr/local/bin/startup.sh

CMD ["/usr/local/bin/startup.sh"]
