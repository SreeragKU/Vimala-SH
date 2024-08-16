<?php
include '../connection.php';

$response = array();

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    // Check if the user_id is provided
    if (isset($_GET['user_id'])) {
        $user_id = $_GET['user_id'];

        // Prepare the SQL query to fetch achievements
        $query = "SELECT * FROM achievements WHERE user_id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param('i', $user_id);

        if ($stmt->execute()) {
            $result = $stmt->get_result();
            $achievements = array();

            // Fetch all achievements
            while ($row = $result->fetch_assoc()) {
                $achievements[] = $row;
            }

            $response['success'] = true;
            $response['achievements'] = $achievements;
        } else {
            $response['success'] = false;
            $response['message'] = 'Failed to fetch achievements.';
        }
        $stmt->close();
    } else {
        $response['success'] = false;
        $response['message'] = 'user_id parameter is missing.';
    }
} else {
    $response['success'] = false;
    $response['message'] = 'Invalid request method.';
}

header('Content-Type: application/json');
echo json_encode($response);
