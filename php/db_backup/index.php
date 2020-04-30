<?php

require 'vendor/autoload.php';

$db_username = 'root';
$db_password = 'root';

$db = new PDO('mysql:host=db', $db_username, $db_password);
$db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);
$exclude = ['information_schema', 'mysql', 'performance_schema', 'sys', 'phpmyadmin'];

$q = $db->query('SHOW DATABASES');
$databases = $q->fetchAll();

?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.5.0.min.js" integrity="sha256-xNzN2a4ltkB44Mc/Jz3pT4iU1cmeR0FkXs4pru/JxaQ=" crossorigin="anonymous"></script>
    <script src="main.js"></script>
    <title>DB backup</title>
</head>

<body>
    <div class="container-fluid mt-2">
        <p class="h1">Db Backup tool</p><input type="button" onclick="dumpAll()" class="btn btn-outline-primary btn-all"value="dump all db">
        <p class="h2">Your DB : </p>
        <ul>
            <?php foreach ($databases as $db) :
                if (!in_array($db->Database, $exclude)) : ?>
                    <li class="list-group-item list-with-btn"><?= $db->Database ?><input class="btn btn-outline-primary btn-li" type="button" value="dump" onclick="dumpOnce('<?= $db->Database ?>')"></li>
            <?php endif;
            endforeach; ?>
        </ul>
    </div>
</body>

</html>