# DOCKER ENV FOR WEB DEVELOPER

![GitHub stars](https://img.shields.io/github/stars/Crash-Zeus/webdeveloper-docker-env?style=social)

The easiest way for local web dev environnement

----------------------

## Requirements :

- docker
- docker-compose

----------------------
Include :

- PHP 7.4.5 with Xdebug v2.9.4

- symfony 4.14.3

- Composer

- Apache server 2.4.38

- Fancy-Index from https://github.com/Vestride/fancy-index

- Mysql server 8.0.19

- PhpMyAdmin 5.0.2

- MailDev 1.1.0

-----------
## Gallery
View of fancy index (color depend of ur system)

![Fancy index](img/fancy_index.png)

View of PhpMyAdmin (default theme, but activated only after login & reload page)

![PMA](img/pma.png)

View of maildev

![MailDev](img/maildev.png)

View of docker

![Docker](img/docker.png)

View of xdebug working

![Docker](img/xdebug.png)


-----------
## How to start

### Two way :

Run ./install.sh

```bash
    ./install.sh mode
```

Mode available :

- cron (Add cron for launch container always on startup)
- alias (No cron but alias created to launch all docker)


OR

- Use ./docker_start.sh and ./docker_stop.sh (or docker-compose up -d & down in this folder)

-----------

# Data

Mysql data stored into mysql folder (persitant)

Php folder used like /var/www/html folder (persitant)

Store all your websites into php folder

You can modify all conf from conf folder (not persistant, need build to effect)

Logs for apache & php available in logs folder (persistant)

-----------

## Route

Local --> http://127.0.0.1

Local with TLS --> https://127.0.0.1 (accepte risk for autosigned certificat)

PhpMyAdmin --> http://127.0.0.1:8090/

MailDev --> http://127.0.0.1:1080

-----------

## Configuration

### PhpMyAdmin / Mysql logs : 
```
    Username : root

    Password : root
```

### Database Host
```
    db
```

### Exemple DB conf php
```php
return [
	"db_user" => "root",
	"db_password" => "root",
	"db_host" => "db",
	"db_name" => "db_test"
];
```

### Config X-Debug with vscode
Replace `your_folder` with the name of folder you want to debug

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/var/www/html/your_folder/": "${workspaceFolder}"
            }
        }

    ]
}
```

-----------


PR & issues open !

Enjoy :D
