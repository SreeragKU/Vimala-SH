<?php
include '../connection.php';
require_once '../vendor/autoload.php';

// Function to fetch the toggle status from the database
function fetchToggleStatus($conn)
{
    $query = "SELECT status FROM toggle_status ORDER BY last_updated DESC LIMIT 1";
    $result = mysqli_query($conn, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        return $row['status'] ? true : false;
    } else {
        return false; // Default to false if no status found
    }
}

// Function to insert or update the toggle status
function insertOrUpdateToggleStatus($conn, $status)
{
    $query = "SELECT id FROM toggle_status ORDER BY last_updated DESC LIMIT 1";
    $result = mysqli_query($conn, $query);

    if ($result && mysqli_num_rows($result) > 0) {
        // Record exists, update it
        $row = mysqli_fetch_assoc($result);
        $id = $row['id'];
        $query = "UPDATE toggle_status SET status = ?, last_updated = NOW() WHERE id = ?";
        $stmt = mysqli_prepare($conn, $query);
        mysqli_stmt_bind_param($stmt, 'ii', $status, $id);
    } else {
        // No record exists, insert a new one
        $query = "INSERT INTO toggle_status (status, last_updated) VALUES (?, NOW())";
        $stmt = mysqli_prepare($conn, $query);
        mysqli_stmt_bind_param($stmt, 'i', $status);
    }

    if (mysqli_stmt_execute($stmt)) {
        return ['success' => true];
    } else {
        return ['success' => false, 'message' => mysqli_error($conn)];
    }
}

header('Content-Type: application/json');

// Handle GET request
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $status = fetchToggleStatus($conn);
    echo json_encode(['status' => $status]);
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    if (isset($data['status'])) {
        $status = $data['status'] ? 1 : 0;
        $response = insertOrUpdateToggleStatus($conn, $status);
        echo json_encode($response);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
    }
}
