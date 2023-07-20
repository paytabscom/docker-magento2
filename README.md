# PayTabs: Docker for Magento2 development

Docker environment to develop the paytabs Magento2 plugin

---

# Wiki

## How to use?

1. Clone this repo
2. Rename `.env.sample` to `.env` and add the correct values
3. Rename `magento.env.sample` to `magento.env` and add the correct values
4. Clone the `paytabs-magento2.x` repo https://github.com/paytabscom/paytabs-magento2.x
5. Inside the docker folder run `docker compose up -d`
6. Enter to Magento container and excute `/usr/local/bin/magento/setup_magento.sh`

**Note:**

Both repos must be at the same level

---

## Database connection from Local

```
host: localhost
port: 3306
```

```
username: magento
password: magento
```
