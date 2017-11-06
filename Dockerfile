FROM fluent/fluentd:v0.14-onbuild
MAINTAINER Yuya Kusakabe <yuya.kusakabe@gmail.com>

RUN apk add --update --virtual .build-deps \
        sudo build-base ruby-dev \
 && sudo gem install eventmachine \
 && sudo gem install fluent-plugin-twitter \
 && sudo gem install fluent-plugin-slack \
 && sudo gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
           /home/fluent/.gem/ruby/2.3.0/cache/*.gem

# override entrypoint.sh
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

# override CMD
CMD
