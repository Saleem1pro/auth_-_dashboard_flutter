<?php
header('Content-Type: application/json');
include "db.php";

$stmt = $db->prepare("SELECT id,name, age FROM student");
$stmt->execute();
$result = $stmt->get_result();

$data = [];
while ($row = $result->fetch_assoc()) {
    $data[] = $row;
}

echo json_encode($data);
