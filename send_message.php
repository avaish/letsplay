<?php

require_once('connect.php');

$dm_id = $_GET["dm_id"];
$user_id = $_GET["user_id"];
$message = mysqli_real_escape_string($con, $_GET["message"]);

$query = "insert into messages (dm_id, user_id, message) values ("
  . $dm_id . ", " . $user_id . ", '" . $message . "');";

mysqli_query($con, $query);

?>