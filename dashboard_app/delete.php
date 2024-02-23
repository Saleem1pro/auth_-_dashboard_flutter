<?php
header('Content-Type: application/json');
include "db.php";

if ($_SERVER["REQUEST_METHOD"] == 'POST') {
    $id = (int) $_POST['id'];

    try {
        require_once "db.php";
        $stmt = $db->prepare("DELETE FROM student WHERE id = ?");
        $stmt->bind_param("i", $id);
        $result = $stmt->execute();

        if ($result) {
            echo json_encode(array("message" => "Étudiant supprimé avec succès"));
        } else {
            echo json_encode(array("message" => "Échec de la suppression de l'étudiant"));
        }

        $stmt->close();
        $db->close();
        exit();
    } catch (mysqli_sql_exception $e) {
        die("Query failed: " . $e->getMessage());
    }
}
?>
