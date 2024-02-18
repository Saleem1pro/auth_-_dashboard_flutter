<?php

// Démarrage de la session
session_start();
header('Access-Control-Allow-Origin: *');

header('Access-Control-Allow-Methods: GET, POST,DELETE, PUT, OPTIONS');

header("Access-Control-Allow-Headers: X-Requested-With");if ($_SERVER["REQUEST_METHOD"] == "POST" || $_SERVER["REQUEST_METHOD"] == "GET") ;

// Vérifier si l'utilisateur est connecté
if (!isset($_SESSION['user_id'])) {
    // Rediriger vers la page de connexion si l'utilisateur n'est pas connecté
    header('Location: login.php');
    exit();
}

// Connexion à la base de données (à adapter selon votre configuration)
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "test_dashboard";

$conn = new mysqli($servername, $username, $password, $dbname);

// Vérifier la connexion
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Traitement des différentes actions

// Ajouter un nouvel élément
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["new_item"])) {
    $newItem = $_POST["new_item"];
    $userId = $_SESSION['user_id'];
    
    $sql = "INSERT INTO user_items (user_id, item) VALUES ('$userId', '$newItem')";
    
    if ($conn->query($sql) === TRUE) {
        // Réponse avec succès
        http_response_code(200);
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}

// Supprimer des éléments sélectionnés
if ($_SERVER["REQUEST_METHOD"] == "DELETE" && isset($_POST["item_ids"])) {
    $itemIds = $_POST["item_ids"];
    $userId = $_SESSION['user_id'];
    
    $itemIdsString = implode(",", $itemIds);
    
    $sql = "DELETE FROM user_items WHERE user_id = '$userId' AND id IN ($itemIdsString)";
    
    if ($conn->query($sql) === TRUE) {
        // Réponse avec succès
        http_response_code(200);
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }
}

// Dupliquer des éléments sélectionnés
if ($_SERVER["REQUEST_METHOD"] == "PUT" && isset($_POST["new_values"])) {
    $newValues = $_POST["new_values"];
    $userId = $_SESSION['user_id'];
    
    foreach ($newValues as $value) {
        $sql = "INSERT INTO user_items (user_id, item) VALUES ('$userId', '$value')";
        
        if ($conn->query($sql) !== TRUE) {
            echo "Error: " . $sql . "<br>" . $conn->error;
            exit();
        }
    }
    
    // Réponse avec succès
    http_response_code(200);
}

// Récupérer les éléments de l'utilisateur connecté
$userId = $_SESSION['user_id'];
$sql = "SELECT * FROM user_items WHERE user_id = '$userId'";
$result = $conn->query($sql);

$userItems = array();
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $userItems[] = $row;
    }
}

// Fermer la connexion à la base de données
$conn->close();
