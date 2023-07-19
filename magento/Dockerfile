FROM php:8.2-apache

ARG Magento_Version
ARG Magento_Key_Public
ARG Magento_Key_Private

ENV COMPOSER_ALLOW_SUPERUSER=1


# SSL setup

RUN openssl req -x509 -nodes -days 999 -newkey rsa:2048 \
    -keyout /etc/ssl/private/pt-integration-selfsigned.key \
    -out /etc/ssl/certs/pt-integration-selfsigned.crt \
    -subj "/C=AE/ST=Dubai/L=Dubai/O=PayTabs Integration/OU=Web Integration/CN=localhost/"

COPY ./assets/sites/default-ssl.conf /etc/apache2/sites-available/


# Apache Server setup

RUN cd /etc/apache2/sites-available \
    && a2enmod ssl \
    && a2enmod rewrite \
    && a2ensite default-ssl \
    && service apache2 restart

# Server setup

RUN apt update && apt install -y \
    git zip unzip wget \
    libzip-dev \
    libpng-dev libjpeg-dev libfreetype6-dev libjpeg62-turbo-dev \
    libbz2-dev \
    libicu-dev \
    libxml2-dev libxslt-dev \
    libsodium-dev

# PHP extensions setup

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure opcache --enable-opcache

RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  bz2 \
  gd \
  intl \
  pdo_mysql \
  opcache \
  soap \
  sockets \
  sodium \
  simplexml \
  xsl \
  zip

RUN docker-php-ext-enable bcmath gd intl pdo_mysql simplexml soap xsl zip sockets

# Configure PHP ini

RUN cat > /usr/local/etc/php/conf.d/docker-php-ext-magento.ini <<EOF
memory_limit=2G
realpath_cache_size=10M
realpath_cache_ttl=7200
EOF

WORKDIR /var/www/html/

# Composer installtion
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN composer global config http-basic.repo.magento.com ${Magento_Key_Public} ${Magento_Key_Private}

RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=${Magento_Version} .

# Magento Auth keys
RUN cat > auth.json <<EOF
{
  "http-basic": {
    "repo.magento.com": {
      "username": "${Magento_Key_Public}",
      "password": "${Magento_Key_Private}"
    }
  }
}
EOF


RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
    && chown -R :www-data . \
    && chmod u+x bin/magento
