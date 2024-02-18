<?php
// Connexion à la base de données
$dbhost = "localhost";
$dbuser = "votre_utilisateur";
$dbpass = "votre_mot_de_passe";
$dbname = "votre_base_de_données";

$conn = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

if (!$conn) {
    die("Erreur de connexion à la base de données : " . mysqli_connect_error());
}

// Traitement du formulaire d'inscription
if (isset($_POST['register'])) {
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $email = mysqli_real_escape_string($conn, $_POST['email']);
    $password = password_hash($_POST['password'], PASSWORD_DEFAULT); // Cryptage du mot de passe

    // Insérer les données dans la table des utilisateurs
    $sql = "INSERT INTO user_list (username, email, password) VALUES ('$username', '$email', '$password')";

    if (mysqli_query($conn, $sql)) {
        echo "Inscription réussie !";
    } else {
        echo "Erreur lors de l'inscription : " . mysqli_error($conn);
    }
}

mysqli_close($conn);
