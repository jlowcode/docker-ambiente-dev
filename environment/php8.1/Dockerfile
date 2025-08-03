# Usa a imagem base do PHP com Apache
FROM php:8.1-apache 

# Define umask padrão para novos arquivos/diretórios
ENV UMASK=0002

# Instala o Xdebug
RUN pecl install xdebug-3.3.1 \
    && docker-php-ext-enable xdebug

# Instala extensões e utilitários do sistema, incluindo Imagick e dependências
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev \
    zlib1g-dev libzip-dev \
    git wget curl gnupg2 ca-certificates unzip \
    nodejs npm openjdk-17-jdk nano \
    default-mysql-client \
    imagemagick libmagickwand-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure zip \
    && docker-php-ext-install gd pdo pdo_mysql mysqli zip \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configurações do Apache
RUN a2enmod rewrite
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Configurações do Xdebug
RUN echo "zend_extension=xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.start_with_request = yes" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.discover_client_host = 1" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo "xdebug.remote_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini

# Configurações personalizadas de upload e memória
RUN echo "post_max_size = 100M" > /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/custom.ini

# Garante umask padrão ao iniciar bash e apache
RUN echo "umask 0002" >> /etc/bash.bashrc && \
    echo "umask 0002" >> /etc/profile

# Copia o script de inicialização para dentro do container
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Expõe a porta 80
EXPOSE 80

# Roda o script init.sh que atualiza os repositórios e depois inicia o apache
CMD ["/usr/local/bin/init.sh"]
