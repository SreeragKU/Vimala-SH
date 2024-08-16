<?php
include '../connection.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Retrieve and sanitize input
    $data = json_decode(file_get_contents('php://input'), true);

    if (isset($data['id']) && isset($data['date']) && isset($data['description'])) {
        $id = $data['id'];
        $date = $data['date'];
        $description = $data['description'];

        // Prepare the update SQL query
        $query = "UPDATE achievements SET date = ?, description = ? WHERE id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param('ssi', $date, $description, $id);

        if ($stmt->execute()) {
            $response['success'] = true;
            $response['message'] = 'Achievement updated successfully.';
        } else {
            $response['success'] = false;
            $response['message'] = 'Failed to update achievement.';
        }
        $stmt->close();
    } else {
        $response['success'] = false;
        $response['message'] = 'Invalid input data.';
    }
}

header('Content-Type: application/json');
echo json_encode($response);
