<?php

require_once('connect.php');

$username = $_POST["username"];
$unencrypted = $_POST["password"];

$query = "select * from users where username = '" . $username . "';";
$result = mysqli_query($con, $query);

$valid = -1;
while($row = mysqli_fetch_array($result)) {
  $salt = $row['salt'];
  $password = sha1($unencrypted . $salt);
  if ($password == $row['password']) {
    $valid = $row['id'];
    $last_login = date("Y-m-d H:i:s");
    
    $query = "update users set last_login = '" . $last_login . "' where id = "
      . $valid . ";";
    mysqli_query($con, $query);
  }
}

echo '{"source": "login", "response":"' . $valid . '"}';
?>