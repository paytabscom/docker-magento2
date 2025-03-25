ARG PHP_Version

FROM wajihkm/pt-php${PHP_Version}:latest

ARG Magento_Version
ARG Magento_Key_Public
ARG Magento_Key_Private

ENV COMPOSER_ALLOW_SUPERUSER=1


# Configure PHP ini

RUN cat > /usr/local/etc/php/conf.d/docker-php-ext-magento.ini <<EOF
memory_limit=8G
realpath_cache_size=10M
realpath_cache_ttl=7200
max_input_vars=3000
upload_max_filesize=100M
EOF

# Configure PHP ini


# Magento preparation & installtion

# Add Composer Auth keys
RUN composer global config http-basic.repo.magento.com ${Magento_Key_Public} ${Magento_Key_Private}

# 1. Get the metapackage
RUN composer create-project \
  --no-interaction \
  --no-install \
  --repository-url=https://repo.magento.com/ \
  magento/project-community-edition=${Magento_Version} .

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

RUN composer install

# 2. Set file permissions
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
    && chown -R :www-data . \
    && chmod u+x bin/magento

# 3. Install Magento

# 3.1. Copy installation files
COPY ./scripts/setup_magento.sh /usr/local/bin/magento/

# 3.2. Add executable permission 
RUN chmod +x /usr/local/bin/magento/*.sh

# 3.3. Run after starting all containers
# /usr/local/bin/magento/setup_magento.sh
