<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include '../connection.php';

// Get user ID from request
if (isset($_GET['user_id'])) {
    $user_id = $_GET['user_id'];
} else {
    die("Error: User ID is not provided");
}

// Set up log file
$log_file = __DIR__ . "/update_log_$user_id.txt";
file_put_contents($log_file, "Process started\n", FILE_APPEND);

// Get JSON data from request body
$json_data = file_get_contents('php://input');

// Log received JSON data
file_put_contents($log_file, "Received JSON data: $json_data\n", FILE_APPEND);

// Decode JSON data
$data = json_decode($json_data, true);

// Check if JSON decoding was successful
if ($data === null && json_last_error() !== JSON_ERROR_NONE) {
    $error_message = "Error: Failed to decode JSON data";
    file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
    die($error_message);
}

// Check if record exists for the user in tbl_family
$sqlCheckRecord = "SELECT COUNT(*) AS count FROM tbl_family WHERE user_id = $user_id";
$result = $conn->query($sqlCheckRecord);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $count = $row['count'];

    if ($count > 0) {
        // Record exists, perform update
        updateFamilyDetails($conn, $user_id, $data, $log_file);
    } else {
        // Record doesn't exist, perform insert followed by update
        insertFamilyDetails($conn, $user_id, $log_file);
        updateFamilyDetails($conn, $user_id, $data, $log_file);
    }
} else {
    // Error querying database
    $error_message = "Error: Failed to check existing record";
    echo $error_message . "\n";
    file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
}

$conn->close();

// Function to insert initial data into tbl_family
function insertFamilyDetails($conn, $user_id, $log_file)
{
    $sqlInsert = "INSERT INTO tbl_family (user_id) VALUES ($user_id)";
    if ($conn->query($sqlInsert) === TRUE) {
        $message = "New record created successfully";
        echo $message . "\n";
        file_put_contents($log_file, $message . "\n", FILE_APPEND);
    } else {
        $error_message = "Error creating new record: " . $conn->error;
        echo $error_message . "\n";
        file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
    }
}

// Function to update family details in tbl_family
function updateFamilyDetails($conn, $user_id, $data, $log_file)
{
    updateFatherDetails($conn, $user_id, $data, $log_file);
    updateMotherDetails($conn, $user_id, $data, $log_file);
    updateGuardianDetails($conn, $user_id, $data, $log_file);
}

// Function to update Father's details
function updateFatherDetails($conn, $user_id, $data, $log_file)
{
    if (isset($data['Father Name 0'])) {
        $fatherName = $conn->real_escape_string($data['Father Name 0']);
        $dobFather = $conn->real_escape_string($data['Father DOB 0']);
        $dodFather = $conn->real_escape_string($data['Father DOD 0']);
        $fatherAddress = $conn->real_escape_string($data['Father Address 0']);
        $fatherOccupation = $conn->real_escape_string($data['Father Occupation 0']);
        $fatherParishDioceseNow = $conn->real_escape_string($data['Father Parish/Diocese Now 0']);
        $fatherParishDioceseBirth = $conn->real_escape_string($data['Father Parish/Diocese at Birth 0']);

        $sqlUpdateFather = "UPDATE tbl_family SET
                            father_name = '$fatherName',
                            dob_father = '$dobFather',
                            dod_father = '$dodFather',
                            father_address = '$fatherAddress',
                            father_occupation = '$fatherOccupation',
                            father_parish_diocese_now = '$fatherParishDioceseNow',
                            father_parish_diocese_birth = '$fatherParishDioceseBirth'
                            WHERE user_id = $user_id";

        if ($conn->query($sqlUpdateFather) === TRUE) {
            $message = "Father's details updated successfully";
            echo $message . "\n";
            file_put_contents($log_file, $message . "\n", FILE_APPEND);
        } else {
            $error_message = "Error updating Father's details: " . $conn->error;
            echo $error_message . "\n";
            file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }
    } else {
        $error_message = "Error: Father's details not provided in JSON data";
        echo $error_message . "\n";
        file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
    }
}

// Function to update Mother's details
function updateMotherDetails($conn, $user_id, $data, $log_file)
{
    if (isset($data['Mother Name 0'])) {
        $motherName = $conn->real_escape_string($data['Mother Name 0']);
        $dobMother = $conn->real_escape_string($data['Mother DOB 0']);
        $dodMother = $conn->real_escape_string($data['Mother DOD 0']);
        $motherOccupation = $conn->real_escape_string($data['Mother Occupation 0']);

        $sqlUpdateMother = "UPDATE tbl_family SET
                            mother_name = '$motherName',
                            dob_mother = '$dobMother',
                            dod_mother = '$dodMother',
                            mother_occupation = '$motherOccupation'
                            WHERE user_id = $user_id";

        if ($conn->query($sqlUpdateMother) === TRUE) {
            $message = "Mother's details updated successfully";
            echo $message . "\n";
            file_put_contents($log_file, $message . "\n", FILE_APPEND);
        } else {
            $error_message = "Error updating Mother's details: " . $conn->error;
            echo $error_message . "\n";
            file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }
    } else {
        $error_message = "Error: Mother's details not provided in JSON data";
        echo $error_message . "\n";
        file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
    }
}

// Function to update Guardian's details
function updateGuardianDetails($conn, $user_id, $data, $log_file)
{
    if (isset($data['Guardian Name 0'])) {
        $guardianName = $conn->real_escape_string($data['Guardian Name 0']);
        $guardianAddressPhone = $conn->real_escape_string($data['Guardian Address/Phone 0']);
        $guardianRelation = $conn->real_escape_string($data['Guardian Relation 0']);

        $sqlUpdateGuardian = "UPDATE tbl_family SET
                              guardian_name = '$guardianName',
                              guardian_address_phone = '$guardianAddressPhone',
                              guardian_relation = '$guardianRelation'
                              WHERE user_id = $user_id";

        if ($conn->query($sqlUpdateGuardian) === TRUE) {
            $message = "Guardian's details updated successfully";
            echo $message . "\n";
            file_put_contents($log_file, $message . "\n", FILE_APPEND);
        } else {
            $error_message = "Error updating Guardian's details: " . $conn->error;
            echo $error_message . "\n";
            file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }
    } else {
        $error_message = "Error: Guardian's details not provided in JSON data";
        echo $error_message . "\n";
        file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
    }
}
