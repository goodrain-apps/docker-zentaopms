FROM alpine:3.3

ENV LAST_RELEASE_URL http://dl.cnezsoft.com/zentao/8.4/ZenTaoPMS.8.4.stable.zip
ENV LAST_RELEASE_FILENAME ZenTaoPMS.8.4.stable.zip
ENV APACHE_CONFIG /etc/apache2/httpd.conf
ENV PHP_CONFIG /etc/php/php.ini

# change timezone to Asia/Shanghai
# add bash libc package
RUN apk add --no-cache tzdata bash libc6-compat && \
    cp  /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone && \
    ln -s /lib /lib64 && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd && \
    sed -i -r 's/nofiles/apache/' /etc/group && \
    adduser -u 200 -D -S -G apache apache && \
    apk del --no-cache tzdata


# install apache2 and php
RUN apk add --no-cache apache2\
    apache2-utils \
    php \
    php-apache2 \
    php-bz2 \
    php-ctype \
    php-curl \
    php-curl \
    php-dom \
    php-iconv \
    php-json \
    php-mcrypt \
    php-mysql \
    php-mysqli \
    php-opcache \
    php-openssl \
    php-pdo \
    php-pdo_mysql \
    php-phar \
    php-posix \
    php-sockets \
    php-xml \
    php-xmlreader \
    php-zip \
    php-zlib 

# modify apache config
RUN sed -i -r 's/#(ServerName) .*/\1 localhost:80/' $APACHE_CONFIG && \
    sed -i -r 's#(/var/www/localhost/htdocs)#/app/www#g' $APACHE_CONFIG && \
    sed -i -r 's#(Options) Indexes (FollowSymLinks)#\1 \2#' $APACHE_CONFIG && \ 
    sed -i -r 's#(AllowOverride) None#\1 All#g' $APACHE_CONFIG && \
    sed -i -r 's#(ErrorLog) logs/error.log#\1 /dev/stderr#' $APACHE_CONFIG && \
    sed -i -r 's#(CustomLog) logs/access.log (combined)#\1 /dev/stdout \2#' $APACHE_CONFIG && \
    sed -i -r 's/#(LoadModule rewrite_module .*)/\1/' $APACHE_CONFIG && \
    mkdir /run/apache2/ && chown apache.apache /run/apache2/

# modify php config
RUN sed -i -r 's/(post_max_size) =.*/\1 = 50M/' $PHP_CONFIG && \
    sed -i -r 's/(upload_max_filesize) =.*/\1 = 50M/' $PHP_CONFIG && \
    sed -i -r 's/; (max_input_vars) =.*/\1 = 3000/' $PHP_CONFIG && \
    sed -i -r 's#;(date.timezone) =.*#\1 = Asia/Shanghai#' $PHP_CONFIG && \
    sed -i -r 's#;(session.save_path) = .*#\1 = "/dev/shm"#' $PHP_CONFIG

# download tendaocms
RUN curl -s -fSL $LAST_RELEASE_URL -o /tmp/$LAST_RELEASE_FILENAME && \
    cd /tmp && unzip -q $LAST_RELEASE_FILENAME && \
    mv zentaopms /app && \
    chown apache.apache /app -R && \
    sed -i -r 's/(php_*)/#\1/g' /app/www/.htaccess

WORKDIR /app

VOLUME /data

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
