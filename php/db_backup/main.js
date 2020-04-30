function dumpOnce(dbName) {
    $.ajax({
        method: 'POST',
        url: 'process.php',
        data: {
            action: 1,
            dbName: dbName
        },
        success: function() {
            alert('Dump ' + dbName + '.sql created');
        }
    })
}
function dumpAll() {
    $.ajax({
        method: 'POST',
        url: 'process.php',
        data: {
            action: 2
        },
        success: function() {
            alert('Dump all database ok');
        }
    })
}