<?php
include '../connection.php';

// SQL query to insert a new record with default values
$sqlInsert = "INSERT INTO tbl_user_details 
                (user_name, official_name, baptism_name, pet_name, church_dob, school_dob, birth_place, baptism_place, 
                baptism_date, confirmation_date, confirmation_place, ph_no, date_first_profession, date_final_profession,
                date_begin_service, date_retire, position, tdate, dod)
              VALUES 
                ('', 'New Member', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')";

// Perform the SQL query
if ($conn->query($sqlInsert) === TRUE) {
    $newUserId = $conn->insert_id;
    echo json_encode(array("success" => true, "user_id" => $newUserId));
} else {
    echo json_encode(array("success" => false, "message" => "Error inserting record: " . $conn->error));
}
