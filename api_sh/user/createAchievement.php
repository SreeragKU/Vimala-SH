<?php
include '../connection.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_GET['user_id'];
    $category = $_POST['category'];
    $sub_group = $_POST['sub_group'];
    $title = $_POST['title'];
    $date = $_POST['date'];
    $description = $_POST['description'];

    // Example of a simple SQL insert query
    $query = "INSERT INTO achievements (user_id, category, sub_group, title, date, description) VALUES (?, ?, ?, ?, ?, ?)";
    $stmt = $conn->prepare($query);
    $stmt->bind_param('isssss', $user_id, $category, $sub_group, $title, $date, $description);

    if ($stmt->execute()) {
        $response['success'] = true;
        $response['message'] = 'Achievement added successfully.';
    } else {
        $response['success'] = false;
        $response['message'] = 'Failed to add achievement.';
    }
    $stmt->close();
}

header('Content-Type: application/json');
echo json_encode($response);
