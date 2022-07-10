FROM wyveo/nginx-php-fpm:php74

RUN apt-get update

RUN apt-get install -y php-dev autoconf automake
RUN apt-get install -y php7.4-xdebug

RUN echo "zend_extension=xdebug.so" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.mode=develop,debug,coverage" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.client_port=9000" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.start_with_request=yes" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.remote_host=host.docker.internal" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.log=/tmp/xdebug.log" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini
RUN echo "xdebug.remote_autostart=1" >> /etc/php/7.4/fpm/conf.d/99-xdebug.ini

RUN service nginx restart
RUN service php7.4-fpm restart
