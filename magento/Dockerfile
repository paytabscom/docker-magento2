ARG PHP_Version

FROM wajihkm/pt-php${PHP_Version}:1

ARG Magento_Version
ARG Magento_Key_Public
ARG Magento_Key_Private

ENV COMPOSER_ALLOW_SUPERUSER=1


# Configure PHP ini

RUN cat > /usr/local/etc/php/conf.d/docker-php-ext-magento.ini <<EOF
memory_limit=2G
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

# 2. Set file permissions
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
    && chown -R :www-data . \
    && chmod u+x bin/magento

# 3. Install Magento
# Run setup_magneto.sh from inside the container (/usr/local/bin/magento/)
