<?php

$db_name = "school";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";

$db = mysqli_connect($db_server, $db_user, $db_pass, $db_name);

// Vérifier la connexion
if (!$db) {
    die("Échec de la connexion à la base de données : " . mysqli_connect_error());
}

// Utiliser la connexion pour exécuter des requêtes MySQL

// Fermer la connexion

// Configurer les attributs de la connexion
mysqli_set_charset($db, "utf8"); // Définit le jeu de caractères
mysqli_options($db, MYSQLI_OPT_INT_AND_FLOAT_NATIVE, true); // Utilise les types natifs pour les entiers et les flottants

// Définir les options de requête
mysqli_options($db, MYSQLI_INIT_COMMAND, "SET sql_mode = 'STRICT_TRANS_TABLES'"); // Mode strict pour les tables

