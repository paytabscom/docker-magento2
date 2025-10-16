cd /var/www/html

echo "------- Setup Magento began -------"

bin/magento setup:install \
--base-url=https://localhost/ \
--db-host=${DB_HOST} \
--db-name=${DB_NAME} \
--db-user=${DB_USER} \
--db-password=${DB_PASSWORD} \
--backend-frontname=admin \
--admin-firstname=admin \
--admin-lastname=admin \
--admin-email=wajih@admin.com \
--admin-user=admin \
--admin-password=${Magento_Admin_Pass} \
--language=en_US \
--currency=${Magento_Currency} \
--timezone=Asia/Dubai \
--use-rewrites=1 \
--search-engine=${Search_Engine} \
--${Search_Engine}-host=${Search_Engine_HOST} \
--${Search_Engine}-port=${Search_Engine_PORT}


echo "------- Setup Magento Configure -------"

bin/magento module:disable Magento_AdminAdobeImsTwoFactorAuth
bin/magento module:disable Magento_TwoFactorAuth

# Password lifetime forever
bin/magento config:set admin/security/password_lifetime 0
bin/magento config:set admin/security/password_is_forced 0

# Increase the Admin session lifetime to 1 day
bin/magento config:set admin/security/session_lifetime 86400


echo "------- Deploy Magento Sample data -------"

bin/magento sampledata:deploy

mkdir pub/media/catalog/product/cache
chmod g+ws pub/media/catalog/product/cache


echo "------- Magento Applying changes -------"

bin/magento setup:upgrade
bin/magento c:f


echo "------- Setup Magento Done -------"
