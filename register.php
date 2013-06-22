<?php

require_once('connect.php');

$username = $_POST["username"];
$unencrypted = $_POST["password"];

$salt = substr(uniqid(mt_rand(), true), 0, 5);
$password = sha1($unencrypted . $salt);

$llat = $_POST["llat"];
$llong = $_POST["llong"];
$last_login = date("Y-m-d H:i:s");

$query = "select id from users where username = '" . $username . "';";
$result = mysqli_query($con, $query);

$dup = 0;
while($row = mysqli_fetch_array($result)) {
  $dup = 1;
}

if ($dup == 0) {
  $query = "insert into users (username, password, salt, llat, llong, last_login)"
    . " values ('" . $username . "', '" . $password . "', '" . $salt . "', " 
    . $llat . ", " . $llong . ", '" . $last_login . "');";

  mysqli_query($con, $query);
  
  $query = "select id from users where username = '" . $username . "';";
  $result = mysqli_query($con, $query);
  
  while($row = mysqli_fetch_array($result)) {
    echo '{"source": "register", "response":"' . $row['id'] . '"}';
  }
}
else {
  echo '{"source": "register", "response":"-1"}';
}

?>