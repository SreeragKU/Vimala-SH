<?php
include '../connection.php';

// Function to safely delete a file
function deleteFile($filePath)
{
    if (file_exists($filePath) && $filePath !== '../../../img/avatar.jpg') {
        if (!unlink($filePath)) {
            return false;
        }
    }
    return true;
}

// Check if member ID is provided and delete the member
if (isset($_GET['user_id'])) {
    $uid = $_GET['user_id'];

    // Remove files associated with tbl_personaldata
    $personalDataImages = array('history_url', 'handwriting_url');
    foreach ($personalDataImages as $imageField) {
        $result = $conn->query("SELECT $imageField FROM tbl_personaldata WHERE user_id = '$uid'");
        if ($result && $result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $imageUrl = '../../' . $row[$imageField];
                deleteFile($imageUrl);
            }
        }
    }

    // Remove file associated with tbl_user_details if it's not the default avatar
    $result = $conn->query("SELECT img_url FROM tbl_user_details WHERE user_id = '$uid'");
    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $imgUrl = '../../' . $row['img_url'];
        deleteFile($imgUrl);
    }

    // Delete from tables
    $tables = array(
        "tbl_accredit",
        "tbl_user_school",
        "tbl_plus_two",
        "tbl_ugrad",
        "tbl_pg",
        "tbl_family",
        "tbl_sibling",
        "tbl_pris",
        "tbl_spers",
        "tbl_prof_record",
        "tbl_mission",
        "tbl_personaldata",
        "tbl_user_details"
    );

    // Loop through tables and delete records
    foreach ($tables as $table) {
        $deleteQuery = "DELETE FROM $table WHERE user_id = '$uid'";
        if (!$conn->query($deleteQuery)) {
            echo json_encode(array("success" => false, "message" => "Error deleting from table $table: " . $conn->error));
            exit; // Exit if error occurs
        }
    }

    echo json_encode(array("success" => true, "message" => "Member and associated details deleted successfully"));
    exit;
} else {
    echo json_encode(array("success" => false, "message" => "Member ID not provided"));
    exit;
}
