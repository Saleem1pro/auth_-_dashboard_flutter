<?php
header('Content-Type: application/json');
include "db.php";

if ($_SERVER["REQUEST_METHOD"] == 'POST') {
    $id = (int) $_POST['id'];
    $name = $_POST['name'];
    $age = (int) $_POST['age'];

    try {
        require_once "db.php";
        $stmt = $db->prepare("UPDATE student SET name = ?, age = ? WHERE id = $id");
        $stmt->bind_param("sii", $name, $age, $id);
        $result = $stmt->execute();

        if ($result) {
            echo json_encode(array("message" => "Étudiant mis à jour avec succès"));
        } else {
            echo json_encode(array("message" => "Échec de la mise à jour de l'étudiant"));
        }

        $stmt->close();
        $db->close();
        exit();
    } catch (mysqli_sql_exception $e) {
        die("Query failed: " . $e->getMessage());
    }
}
?>
