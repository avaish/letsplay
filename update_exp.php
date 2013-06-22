<?php

require_once('connect.php');

$user_id = $_GET["user_id"];
$sport_id = $_GET["sport_id"];
$skill = $_GET["skill"];
$experience = $_GET["experience"];

$query = "select * from user_exp where user_id = " . $user_id . " and sport_id"
   . " = " . $sport_id . ";";
$result = mysqli_query($con, $query);

$dup = 0;
while($row = mysqli_fetch_array($result)) {
  $dup = 1;
}

if ($dup == 0) {
  $query = "insert into user_exp (user_id, sport_id, skill, experience)"
    . " values (" . $user_id . ", " . $sport_id . ", " . $skill . ", " 
    . $experience . ");";
}
else {
  $query = "update user_exp set skill = " . $skill . ", experience = " 
    . $experience . " where user_id = " . $user_id . " and sport_id = " 
    . $sport_id . ";";
}

mysqli_query($con, $query);
?>