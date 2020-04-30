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