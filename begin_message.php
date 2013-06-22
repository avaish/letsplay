<?php

require_once('connect.php');

$user_1 = $_GET["user_1"];
$user_2 = $_GET["user_2"];
$sport_id = $_GET["sport_id"];

if ($user_1 > $user_2) {
  $temp = $user_1;
  $user_1 = $user_2;
  $user_2 = $temp;
}

$query = "select id from dir_messages where user_1 = " . $user_1 
  . " and user_2 = " . $user_2 . " and sport_id = " . $sport_id . ";";
$result = mysqli_query($con, $query);

$ret = -1;
while($row = mysqli_fetch_array($result)) {
  $ret = $row["id"];
}

if ($ret == -1) {
  $query = "insert into dir_messages (user_1, user_2, sport_id) values ("
    . $user_1 . ", " . $user_2 . ", " . $sport_id . ");";
  mysqli_query($con, $query);
  
  $query = "select id from dir_messages where user_1 = " . $user_1 
    . " and user_2 = " . $user_2 . " and sport_id = " . $sport_id . ";";
  $result = mysqli_query($con, $query);
  
  while($row = mysqli_fetch_array($result)) {
    $ret = $row["id"];
  }
}

echo $ret;
?>