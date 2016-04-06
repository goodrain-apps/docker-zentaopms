FROM php:5.6-apache

ENV LAST_RELEASE_URL http://dl.cnezsoft.com/zentao/8.1.3/ZenTaoPMS.8.1.3.zip
ENV LAST_RELEASE_FILENAME ZenTaoPMS.8.1.3
ENV APACHE_CONFIG /etc/apache2/apache2.conf
ENV PHP_CONFIG /usr/local/etc/php/php.ini

# configure timezone
RUN echo "Asia/Shanghai" > /etc/timezone;dpkg-reconfigure -f noninteractive tzdata

# add rain user and group
RUN groupadd -g 200 -r rain && useradd -r -g rain -u 200 rain

# Install required libraries
RUN apt-get update && \
    apt-get install -y libbz2-dev libmcrypt-dev unzip wget
    
# Install extensions
RUN docker-php-ext-install opcache bz2 mcrypt mysql mysqli pdo_mysql sockets


# modify apache config
RUN echo "ServerName localhost:80" >> $APACHE_CONFIG && \
    sed -i -r 's/(User) www-data/\1 rain/' $APACHE_CONFIG && \
    sed -i -r 's/(Group) www-data/\1 rain/' $APACHE_CONFIG && \
    sed -i -r 's#(Directory) /var/www/#\1 /app/www#g' $APACHE_CONFIG && \
    sed -i -r 's#(DocumentRoot) .*#\1 /app/www#' $APACHE_CONFIG && \ 
    sed -i -r 's#(AllowOverride) None#\1 All#g' $APACHE_CONFIG && \
    a2enmod rewrite && a2enmod rewrite && a2dismod status

# modify php config
RUN cp /usr/src/php/php.ini-production $PHP_CONFIG && \
    sed -i -r 's/(post_max_size) =.*/\1 = 50M/' $PHP_CONFIG && \
    sed -i -r 's/(upload_max_filesize) =.*/\1 = 50M/' $PHP_CONFIG && \
    sed -i -r 's/; (max_input_vars) =.*/\1 = 3000/' $PHP_CONFIG && \
    sed -i -r 's#;(date.timezone) =.*#\1 = Asia/Shanghai#' $PHP_CONFIG && \
    sed -i -r 's#;(session.save_path) = .*#\1 = "/dev/shm"#' $PHP_CONFIG

# download tendaocms
RUN curl -s -fSL $LAST_RELEASE_URL -o /tmp/$LAST_RELEASE_FILENAME && \
    cd /tmp && unzip -q $LAST_RELEASE_FILENAME && \
    mv zentaopms /app && \
    chown rain.rain /app -R && \
    sed -i -r 's/(php_*)/#\1/g' /app/www/.htaccess

# Clean up useless files
RUN rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/src/php 


WORKDIR /app

VOLUME /data

COPY docker-entrypoint.sh /

EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
