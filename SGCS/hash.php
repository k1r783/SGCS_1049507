<?php
$password = "admin123";   // Change this to the password you want

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

echo "Plain Password: " . $password . "<br>";
echo "Hashed Password: " . $hashedPassword;
?>