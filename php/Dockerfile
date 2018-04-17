FROM php:7.1.16-fpm-alpine
RUN docker-php-ext-install mysqli pdo pdo_mysql

ENV PHPREDIS_VERSION=3.1.6

# Run in single command because it can remove unuse resource
RUN set -xe \
    && docker-php-source extract && cd /usr/src/php/ext \
	&& apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    && curl -OL https://github.com/igbinary/igbinary/archive/2.0.5.tar.gz \
    && tar xzf 2.0.5.tar.gz && cd igbinary-2.0.5 && phpize && ./configure CFLAGS="-O2 -g" --enable-igbinary \
    && make && make install \
    && echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini \
    && cd .. && rm -rf 2.0.5.tar.gz igbinary-2.0.5 \
    && curl -OL https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz \
    && tar xzf ${PHPREDIS_VERSION}.tar.gz && cd phpredis-${PHPREDIS_VERSION} && phpize && ./configure --enable-redis-igbinary \
    && make && make install \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini \
    && cd .. && rm -rf ${PHPREDIS_VERSION}.tar.gz phpredis-${PHPREDIS_VERSION} \
    && curl -LO https://github.com/phalcon/cphalcon/archive/v3.3.2.tar.gz \
    && tar xzf v3.3.2.tar.gz && cd cphalcon-3.3.2/build/ && sh install \
    && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini \
    && cd .. && rm -rf v3.3.2.tar.gz cphalcon-3.3.2 \
    && docker-php-source delete \
    && apk del .build-deps \ 
    && rm -rf /var/cache/apk/*

EXPOSE 9000

CMD ["php-fpm"]