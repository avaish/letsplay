<?php

require_once('connect.php');

$dm_id = $_GET["dm_id"];

$query = "select * from messages where dm_id = " . $dm_id . ";";
$result = mysqli_query($con, $query);

while($row = mysqli_fetch_array($result)) {
  echo $row["user_id"] . ': ' . $row["message"] . '<br />';
}

?>