<?php

require 'vendor/autoload.php';

$db_username = 'root';
$db_password = 'root';

$db = new PDO('mysql:host=db', $db_username, $db_password);
$db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_OBJ);
$exclude = ['information_schema', 'mysql', 'performance_schema', 'sys'];

$q = $db->query('SHOW DATABASES');
$databases = $q->fetchAll();

if (isset($_POST['action']) && $_POST['action'] == '1') {
    $db_name = $_POST['dbName'];
    $file = './dump/' . $db_name . '.sql';
    try {
        $dump = new \Ifsnop\Mysqldump\Mysqldump("mysql:host=db;dbname=$db_name", $db_username, $db_password);
        $dump->start($file);
    } catch (Exception $e) {
        echo "Error on $db_name : " . $e->getMessage() . '<br/>';
    }
}

if (isset($_POST['action']) && $_POST['action'] == '2') {
    foreach ($databases as $database) {
        $db_name = $database->Database;
        if (!in_array($db_name, $exclude)) {
            $file = './dump/' . $db_name . '.sql';
            try {
                $dump = new \Ifsnop\Mysqldump\Mysqldump("mysql:host=db;dbname=$db_name", $db_username, $db_password);
                $dump->start($file);
            } catch (Exception $e) {
                echo "Error on $db_name : " . $e->getMessage() . '<br/>';
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css.css">
    <script src="https://code.jquery.com/jquery-3.5.0.min.js" integrity="sha256-xNzN2a4ltkB44Mc/Jz3pT4iU1cmeR0FkXs4pru/JxaQ=" crossorigin="anonymous"></script>
    <title>DB backup</title>
</head>

<body>
    <h1>DB local backup</h1>
    <input type="button" onclick="dumpAll()" value="dump all db">
    <h2>Your database :</h2>
    <ul>
        <?php foreach ($databases as $db) :
            if (!in_array($db->Database, $exclude)) : ?>
                <li><?= $db->Database ?><input class="btn-li" type="button" value="dump" onclick="dumpOnce('<?= $db->Database ?>')"></li>
        <?php endif;
        endforeach; ?>
    </ul>
</body>

</html>
<script>
    function dumpOnce(dbName) {
        $.ajax({
            method: 'POST',
            url: 'index.php',
            data: {
                action: 1,
                dbName: dbName
            },
            success: function() {
                alert('Dump OK');
            }
        })
    }
    function dumpAll() {
        $.ajax({
            method: 'POST',
            url: 'index.php',
            data: {
                action: 2
            },
            success: function() {
                alert('Dump OK');
            }
        })
    }
</script>