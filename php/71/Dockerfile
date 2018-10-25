FROM php:7.1.22-fpm-alpine

ENV PHPREDIS_VERSION=3.1.6

ENV PHALCON_VERSION=3.2.2

RUN apk add --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN set -xe \
    && apk add --no-cache --virtual .build-deps --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
        $PHPIZE_DEPS \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libwebp-dev \
        libxpm-dev \
        sqlite-dev \
        libxml2-dev \
        libmcrypt-dev \
        pcre-dev \
        cyrus-sasl-dev \
        openssl-dev \
        gettext-dev \
        geoip-dev \
        bzip2-dev \
        icu-dev \
        libxslt-dev \
        libmemcached-dev \
        zlib-dev \
        gd-dev \
        libmhash-dev \
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted \
        freetype \
        libpng \
        libwebp \
        libxpm \
        libjpeg-turbo \
        sqlite \
        libxml2 \
        libmcrypt \
        libsasl \
        cyrus-sasl \
        gettext \
        icu \
        icu-libs \
        geoip \
        libbz2 \
        libxslt \
        libmemcached \
        libmemcached-libs \
        zlib \
        gd \
        libmhash \
    && docker-php-ext-configure gd \
        --with-gd=/usr/include/ \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
        --with-xpm-dir=/usr/include/ \
    && NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NPROC} gd \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_sqlite \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install wddx \
    && docker-php-ext-install calendar \
    && docker-php-ext-install xml \
    && docker-php-ext-install zip \
    && docker-php-ext-install bz2 \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-configure hash --with-mhash \
    && docker-php-ext-install hash \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install exif \
    && docker-php-ext-install gettext \
    && docker-php-ext-install intl \
    && docker-php-ext-install shmop \
    && docker-php-ext-install sockets \
    && docker-php-ext-install xsl \
    && docker-php-ext-install sysvmsg \
    && docker-php-ext-install sysvsem \
    && docker-php-ext-install sysvshm \
    && docker-php-ext-install opcache \
    && pecl install igbinary \
    && pecl install mongodb \
    && pecl install xdebug \
    && pecl install msgpack \
    && pecl install memcached \
    && pecl install geoip-1.1.1 \
    && docker-php-ext-enable \
        igbinary \
        mongodb \
        xdebug \
        msgpack \
        memcached \
        geoip \
    && docker-php-source extract && cd /usr/src/php/ext \
	&& apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && curl -OL https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz \
    && tar xzf ${PHPREDIS_VERSION}.tar.gz && cd phpredis-${PHPREDIS_VERSION} \
    && phpize && ./configure --enable-redis-igbinary \
    && make && make install \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/phpredis.ini \
    && cd .. && rm -rf ${PHPREDIS_VERSION}.tar.gz phpredis-${PHPREDIS_VERSION} \
    && curl -LO https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz && cd cphalcon-${PHALCON_VERSION}/build/ \
    && sh install \
    && echo "extension=phalcon.so" > /usr/local/etc/php/conf.d/phalcon.ini \
    && cd .. && rm -rf v${PHALCON_VERSION}.tar.gz cphalcon-${PHALCON_VERSION} \
    && curl -OL https://github.com/websupport-sk/pecl-memcache/archive/NON_BLOCKING_IO_php7.zip \
    && unzip NON_BLOCKING_IO_php7.zip && cd pecl-memcache-NON_BLOCKING_IO_php7 \
    && phpize && ./configure --enable-memcache \
    && make && make install \
    && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
    && cd .. && rm -rf NON_BLOCKING_IO_php7.zip pecl-memcache-NON_BLOCKING_IO_php7 \
    && docker-php-source delete \
    && apk del .build-deps \ 
    && rm -rf /var/cache/apk/*


RUN docker-php-ext-configure hash --with-mhash

EXPOSE 9000

CMD ["php-fpm"]