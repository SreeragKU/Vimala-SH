<?php
include '../connection.php';

$jsonData = file_get_contents('php://input');
$data = json_decode($jsonData, true);

if (isset($data['user_id']) && isset($data['img_base64'])) {
    $user_id = $data['user_id'];
    $img_base64 = $data['img_base64'];
    $imgData = base64_decode($img_base64);
    $uploadPath = '../../uploads/profilepicture/';
    $fileName = 'user_' . $user_id . '.jpg';
    $filePath = $uploadPath . $fileName;

    if (file_exists($filePath)) {
        unlink($filePath);
    }

    $success = file_put_contents($filePath, $imgData);

    if ($success !== false) {
        $imgUrl = 'uploads/profilepicture/' . $fileName;

        $updateQuery = "UPDATE tbl_user_details SET img_url = ? WHERE user_id = ?";
        $stmt = $conn->prepare($updateQuery);
        $stmt->bind_param('si', $imgUrl, $user_id);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            echo json_encode(array('success' => true, 'message' => 'Image uploaded and database updated.'));
        } else {
            echo json_encode(array('success' => false, 'message' => 'Failed to update database.'));
        }
        $stmt->close();
    } else {
        echo json_encode(array('success' => false, 'message' => 'Failed to save image file.'));
    }
} else {
    echo json_encode(array('success' => false, 'message' => 'Invalid data received.'));
}
$conn->close();
