<?php
include '../connection.php';

function generateRandomNumber()
{
  return mt_rand(1000000000, 2147483647);
}

$logId = generateRandomNumber();

$baptismDate = '0000-00-00';
$confirmationDate = '0000-00-00';

$sqlInsert = "INSERT INTO tbl_user_details 
                (log_id, user_name, official_name, baptism_name, pet_name, church_dob, school_dob, birth_place, baptism_place, 
                baptism_date, confirmation_date, confirmation_place, ph_no, date_first_profession, date_final_profession,
                date_begin_service, date_retire, position, tdate, dod)
              VALUES 
                ('$logId', '', 'New Member', '', '', '', '', '', '', '$baptismDate', '$confirmationDate', '', '', '', '', '', '', '', '', '')";

if ($conn->query($sqlInsert) === TRUE) {
  $newUserId = $conn->insert_id;
  echo json_encode(array("success" => true, "user_id" => $newUserId));
} else {
  echo json_encode(array("success" => false, "message" => "Error inserting record: " . $conn->error));
}

$conn->close();
