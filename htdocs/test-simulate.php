<?php
$started = microtime(true);
$string = 'letsburnsomecpu';
$key = 'mysupersecretkey';
$method = 'AES256';
$iv = 'aninsecureivhere';
$times_run = 0;
while ( $times_run < 50000 ) {
        $encrypted = openssl_encrypt( $string, $method, $key, null, $iv );
        $decrypted = openssl_decrypt( $encrypted, $method, $key, null, $iv );
        $times_run++;
}
// this is the equivalent of talking to mysql
usleep(200000);

while ( $times_run < 50000 ) {
        $encrypted = openssl_encrypt( $string, $method, $key, null, $iv );
        $decrypted = openssl_decrypt( $encrypted, $method, $key, null, $iv );
        $times_run++;
}
$ended = microtime(true);
if (!empty($_GET['print'])) {
    echo '       Php: ' . PHP_VERSION ."\n";
//    echo '   Started: ' . $started ."\n";
//    echo '     Ended: ' . $ended ."\n";
    echo 'Total Time: ' . round( $ended - $started, 4)."\n";
}
