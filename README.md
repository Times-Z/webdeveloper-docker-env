# DOCKER ENV FOR WEB DEVELOPER

The easiest way for local web dev environnement

----------------------

![GitHub stars](https://img.shields.io/github/stars/Crash-Zeus/webdeveloper-docker-env?style=social)

----------------------
Include :

- PHP 7.4.5 

- symfony v4.14.3

- Composer

- Apache 2.4.38 server

- Mysql server 8.0.19

- PhpMyAdmin 5.0.2

- MailDev 1.1.0

-----------
## How to start

Requirement :

Change path into docker_start.sh

---

Two way :

- Run manualy docker_start.sh

OR

- add crontab :
    ```
    crontab -e

    @reboot /your/path/to/docker_start.sh
    ```
-----------

# Data

Mysql data stored into mysql folder (persitant)

Php folder used like /var/www/html folder (persitant)

Store all your websites into php folder

-----------

## Route

Local --> http://127.0.0.1

Local with TLS --> https://127.0.0.1 (accepte risk for autosigned certificat)

PhpMyAdmin --> http://127.0.0.1:8090/

MailDev --> http://127.0.0.1:1080

## Configuration

### PhpMyAdmin / Mysql logs : 
```
    Username : Root

    Password : Root
```

### Database Host
```
    db
```

-----------

Enjoy :D
