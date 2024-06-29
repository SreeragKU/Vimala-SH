<?php
include '../connection.php';

$userName = $_POST['user_name'];
$userPassword = md5($_POST['user_password']);
$sqlQuery = "SELECT * FROM tbl_login WHERE user_name='$userName' AND pword='$userPassword'";
$resultOfQuery = $conn->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $userRecord = $resultOfQuery->fetch_assoc();
    if ($userRecord['status'] != 0) {
        echo json_encode(array(
            "success" => true,
            "userData" => $userRecord,
        ));
    } else {
        echo json_encode(array("success" => false, "message" => "Login failed. Account is inactive."));
    }
} else {
    echo json_encode(array("success" => false, "message" => "Login failed. Check credentials and try again"));
}
