<?php
include '../connection.php';

// Check if an ID is provided
if (isset($_GET['id'])) {
    $id = intval($_GET['id']);

    // Prepare the SQL statement to prevent SQL injection
    $stmt = $conn->prepare("DELETE FROM achievements WHERE id = ?");
    $stmt->bind_param("i", $id);

    // Execute the statement
    if ($stmt->execute()) {
        // Check if a row was affected
        if ($stmt->affected_rows > 0) {
            echo json_encode(['success' => true, 'message' => 'Achievement deleted successfully.']);
        } else {
            echo json_encode(['success' => false, 'message' => 'No achievement found with the given ID.']);
        }
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to delete achievement.']);
    }

    // Close the statement and connection
    $stmt->close();
    $conn->close();
} else {
    echo json_encode(['success' => false, 'message' => 'ID parameter is missing.']);
}
