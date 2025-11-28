ARG PHP_Tag

FROM wajihkm/php:${PHP_Tag}

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


# Magento preparation & installation

# Add Composer Auth keys
RUN composer global config http-basic.repo.magento.com ${Magento_Key_Public} ${Magento_Key_Private}

# 1. Get the meta package
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

# 4. Alias for Magento CLI
RUN alias mage='php /var/www/html/bin/magento' \
  && alias mage-setup='mage s:up' \
  && alias mage-cache-clean='mage c:c' \
  && alias mage-cache-flush='mage c:f'
