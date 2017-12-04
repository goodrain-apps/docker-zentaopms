FROM goodrainapps/alpine:3.6

ENV LAST_RELEASE_URL http://dl.cnezsoft.com/zentao/9.6.2/ZenTaoPMS.9.6.2.zip
ENV LAST_RELEASE_FILENAME ZenTaoPMS.9.6.2.zip
ENV APACHE_CONFIG /etc/apache2/httpd.conf
ENV PHP_CONFIG /etc/php5/php.ini

# change timezone to Asia/Shanghai
# add bash libc package
RUN apk add --no-cache tzdata bash && \
    cp  /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime && \
    echo "Asia/Shanghai" >  /etc/timezone && \
    sed -i -e "s/bin\/ash/bin\/bash/" /etc/passwd && \
    sed -i -r 's/nofiles/apache/' /etc/group && \
    adduser -u 200 -D -S -G apache apache && \
    apk del --no-cache tzdata


# install apache2 and php
RUN apk add --no-cache apache2\
    apache2-utils \
    php5 \
    php5-apache2 \
    php5-bz2 \
    php5-ctype \
    php5-curl \
    php5-curl \
    php5-dom \
    php5-iconv \
    php5-json \
    php5-mcrypt \
    php5-mysql \
    php5-mysqli \
    php5-opcache \
    php5-openssl \
    php5-pdo \
    php5-pdo_mysql \
    php5-phar \
    php5-posix \
    php5-sockets \
    php5-xml \
    php5-xmlreader \
    php5-zip \
    php5-zlib 

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
