<?php

require_once('connect.php');

$user_id = $_POST["user_id"];

$query = "select sport_id, name from user_exp join sports on sport_id = id"
  . " where user_id = " . $user_id;
$result = mysqli_query($con, $query);

$sports = array();
$i = 0;

while($row = mysqli_fetch_array($result)) {
  $t = array();
  $t["id"] = $row['sport_id'];
  $t["name"] = $row['name'];
  $sports[$i] = $t;
  $i++;
}

$ret = array();
$ret["source"] = "get_sports";
$ret["response"] = $sports;

echo json_encode($ret);

?>
