<?php

require_once('connect.php');

$user_id = $_GET["user_id"];
$sport_id = $_GET["sport_id"];
$results = $_GET["results"];

// get our skill/experience (for later)

$clat = 0;
$clong = 0;
$query = "select * from users where id = " . $user_id . ";";
$result = mysqli_query($con, $query);

while($row = mysqli_fetch_array($result)) {
  $clat = $row['llat'];
  $clong = $row['llong'];
}

$query = "select * from user_exp where user_id = " . $user_id . " and sport_id"
   . " = " . $sport_id . ";";
$result = mysqli_query($con, $query);

$skill = 0;
$experience = 0;
while($row = mysqli_fetch_array($result)) {
  $skill = $row['skill'];
  $experience = $row['experience'];
}

// set up location boundaries
$distance = 25;
if ($skill == 3) {
  $distance = 75;
}
if ($skill == 4) {
  $distance = 25000;
}

$i = 0;
$users = array();

// filter users by location
$query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
  . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
  . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
  . "users join user_exp on user_id = id where sport_id = " . $sport_id 
  . " and user_id != " . $user_id . " and skill = " . $skill 
  . " and last_login < DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
  . $distance . " order by abs(" . $experience . " - experience) asc;";

$result = mysqli_query($con, $query);

while($row = mysqli_fetch_array($result)) {
  $users[$i] = $row['id'];
  $i++;
}

$query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
  . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
  . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
  . "users join user_exp on user_id = id where sport_id = " . $sport_id 
  . " and user_id != " . $user_id . " and skill = " . $skill 
  . " and last_login >= DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
  . $distance . " order by abs(" . $experience . " - experience) asc;";

$result = mysqli_query($con, $query);

while($row = mysqli_fetch_array($result)) {
  $users[$i] = $row['id'];
  $i++;
}

if ($skill < 4) {
  $query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
    . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
    . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
    . "users join user_exp on user_id = id where sport_id = " . $sport_id 
    . " and user_id != " . $user_id . " and skill = " . ($skill + 1)
    . " and last_login < DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
    . $distance . " order by abs(" . $experience . " - experience) asc;";

  $result = mysqli_query($con, $query);

  while($row = mysqli_fetch_array($result)) {
    $users[$i] = $row['id'];
    $i++;
  }

  $query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
    . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
    . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
    . "users join user_exp on user_id = id where sport_id = " . $sport_id 
    . " and user_id != " . $user_id . " and skill = " . ($skill + 1) 
    . " and last_login >= DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
    . $distance . " order by abs(" . $experience . " - experience) asc;";

  $result = mysqli_query($con, $query);

  while($row = mysqli_fetch_array($result)) {
    $users[$i] = $row['id'];
    $i++;
  }
}

if ($skill > 1) {
  $query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
    . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
    . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
    . "users join user_exp on user_id = id where sport_id = " . $sport_id 
    . " and user_id != " . $user_id . " and skill = " . ($skill - 1)
    . " and last_login < DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
    . $distance . " order by abs(" . $experience . " - experience) asc;";

  $result = mysqli_query($con, $query);

  while($row = mysqli_fetch_array($result)) {
    $users[$i] = $row['id'];
    $i++;
  }

  $query = "select id, last_login, (3959 * acos(cos(radians(" . $clat . ")) * " 
    . "cos(radians(llat)) * cos(radians(llong) - radians(" . $clong
    . ")) + sin(radians(" . $clat . ")) * sin(radians(llat)))) as distance from "
    . "users join user_exp on user_id = id where sport_id = " . $sport_id 
    . " and user_id != " . $user_id . " and skill = " . ($skill - 1) 
    . " and last_login >= DATE_SUB(now(), INTERVAL 1 WEEK) having distance < " 
    . $distance . " order by abs(" . $experience . " - experience) asc;";

  $result = mysqli_query($con, $query);

  while($row = mysqli_fetch_array($result)) {
    $users[$i] = $row['id'];
    $i++;
  }
}

for($x = 0; $x < $i; $x++)
{
  echo $users[$x];
  echo "<br>";
}

// save user id, recency and calculate rank based on skill/experience

// recency cutoff (one day?)

// rank actives by rank, rank inactives by rank, merge arrays

// take top results

// return list of user ids

?>
