<?php
// Fonction pour générer une clé secrète
function generateSecretKey($length = 32) {
    return bin2hex(random_bytes($length));
}

// Générer une clé secrète sécurisée
$secretKey = generateSecretKey();

// Durée de validité des jetons (en secondes)
define('TOKEN_EXPIRATION', 3600); // 1 heure

// Fonction pour générer un jeton JWT avec une date d'expiration
function generateJWT($payload) {
    $expiration = time() + TOKEN_EXPIRATION; // Date d'expiration du jeton
    $secretKey = generateSecretKey();

    // Ajouter la date d'expiration au payload
    $payload['exp'] = $expiration;

    // En-tête du jeton JWT
    $header = base64_encode(json_encode(['typ' => 'JWT', 'alg' => 'HS256']));

    // Encodage du payload en base64
    $payload = base64_encode(json_encode($payload));

    // Signature du jeton
    $signature = hash_hmac('sha256', "$header.$payload", $secretKey, true);
    $signature = base64_encode($signature);

    // Assemblage du jeton JWT
    $token = "$header.$payload.$signature";

    return $token;
}

// Fonction pour vérifier et décoder un jeton JWT
function decodeJWT($token) {
    // Séparation du jeton en ses composants : en-tête, payload et signature
    list($header, $payload, $signature) = explode('.', $token);
    $secretKey = generateSecretKey();

    // Vérification de la signature
    $computed_signature = base64_encode(hash_hmac('sha256', "$header.$payload", $secretKey, true));
    if ($signature !== $computed_signature) {
        return null; // Signature invalide
    }

    // Décodage du payload
    $decoded_payload = json_decode(base64_decode($payload), true);

    // Vérification de la date d'expiration
    if (isset($decoded_payload['exp']) && $decoded_payload['exp'] >= time()) {
        return $decoded_payload; // Jeton valide
    } else {
        return null; // Jeton expiré
    }
}

// Exemple d'utilisation
$email = 'utilisateur@example.com';
$token = generateJWT(['email' => $email]);

echo "Jetons JWT généré : $token\n";

$decoded_payload = decodeJWT($token);

if ($decoded_payload !== null) {
    echo "Payload décoder : " . print_r($decoded_payload, true) . "\n";
} else {
    echo "Signature invalide ou jeton expiré\n";
}
