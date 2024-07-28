<?php
include '../connection.php';

// Get user ID from request
$user_id = intval($_GET['user_id']);

// Initialize log file
$log_file = __DIR__ . "/update_log_$user_id.txt";
// file_put_contents($log_file, "Process started\n", FILE_APPEND);

// Get JSON data from request body
$json_data = file_get_contents('php://input');
$data = json_decode($json_data, true);

// Save the raw JSON data to a file
$file_path = __DIR__ . "/user_data_$user_id.json";
// file_put_contents($file_path, $json_data);
// file_put_contents($log_file, "Received JSON data and saved to file\n", FILE_APPEND);

// Check if JSON data is properly decoded
if (json_last_error() !== JSON_ERROR_NONE) {
    $error = "Invalid JSON data received.";
    // file_put_contents($log_file, "$error\n", FILE_APPEND);
    echo $error;
    exit;
}

// Sanitize and validate inputs
$official_name = $conn->real_escape_string($data['Official Name'] ?? '');
$baptism_name = $conn->real_escape_string($data['Baptism Name'] ?? '');
$pet_name = $conn->real_escape_string($data['Pet Name'] ?? '');
$church_dob = $conn->real_escape_string($data['Church DOB'] ?? '');
$school_dob = $conn->real_escape_string($data['School DOB'] ?? '');
$birth_place = $conn->real_escape_string($data['Birth Place'] ?? '');
$baptism_place = $conn->real_escape_string($data['Baptism Place'] ?? '');
$baptism_date = $conn->real_escape_string($data['Baptism Date'] ?? '');
$confirmation_date = $conn->real_escape_string($data['Confirmation Date'] ?? '');
$confirmation_place = $conn->real_escape_string($data['Confirmation Place'] ?? '');
$ph_no = $conn->real_escape_string($data['Phone Number'] ?? '');
$date_first_profession = $conn->real_escape_string($data['Date of First Profession'] ?? '');
$date_final_profession = $conn->real_escape_string($data['Date of Final Profession'] ?? '');
$date_begin_service = $conn->real_escape_string($data['Date of Begin Service'] ?? '');
$date_retire = $conn->real_escape_string($data['Date of Retire'] ?? '');
$position = $conn->real_escape_string($data['Position'] ?? '');
$tdate = $conn->real_escape_string($data['Tdate'] ?? '');
$dod = $conn->real_escape_string($data['Date of Death'] ?? '');
$blood_grp = $conn->real_escape_string($data['Blood Group'] ?? '');
$illness_history = $conn->real_escape_string($data['Illness History'] ?? '');
$surgery_history = $conn->real_escape_string($data['Surgery History'] ?? '');
$long_term_treatment = $conn->real_escape_string($data['Long Term Treatment'] ?? '');
$present_health = $conn->real_escape_string($data['Present Health'] ?? '');
$talents = $conn->real_escape_string($data['Talents'] ?? '');
$motto_principles = $conn->real_escape_string($data['Motto Principles'] ?? '');

// Start transaction
$conn->begin_transaction();

try {
    // Check if user exists in tbl_user_details
    $checkUserDetailsQuery = "SELECT * FROM tbl_user_details WHERE user_id = $user_id";
    $userDetailsResult = $conn->query($checkUserDetailsQuery);
    // file_put_contents($log_file, "Checked tbl_user_details for user\n", FILE_APPEND);

    // Check if user exists in tbl_personaldata
    $checkPersonalDataQuery = "SELECT * FROM tbl_personaldata WHERE user_id = $user_id";
    $personalDataResult = $conn->query($checkPersonalDataQuery);
    // file_put_contents($log_file, "Checked tbl_personaldata for user\n", FILE_APPEND);

    if ($userDetailsResult->num_rows == 0) {
        $insertUserDetailsQuery = "INSERT INTO tbl_user_details (user_id) VALUES ($user_id)";
        if ($conn->query($insertUserDetailsQuery) !== TRUE) {
            throw new Exception("Error inserting user details: " . $conn->error);
        }
        // file_put_contents($log_file, "Inserted new user details\n", FILE_APPEND);
    }

    if ($personalDataResult->num_rows == 0) {
        $insertPersonalDataQuery = "INSERT INTO tbl_personaldata (user_id) VALUES ($user_id)";
        if ($conn->query($insertPersonalDataQuery) !== TRUE) {
            throw new Exception("Error inserting personal data: " . $conn->error);
        }
        // file_put_contents($log_file, "Inserted new personal data\n", FILE_APPEND);
    }

    // Update tbl_user_details
    $updateUserDetailsQuery = "UPDATE tbl_user_details SET 
        user_name = '$official_name',
        official_name = '$official_name',
        baptism_name = '$baptism_name',
        pet_name = '$pet_name',
        church_dob = '$church_dob',
        school_dob = '$school_dob',
        birth_place = '$birth_place',
        baptism_place = '$baptism_place',
        baptism_date = '$baptism_date',
        confirmation_date = '$confirmation_date',
        confirmation_place = '$confirmation_place',
        ph_no = '$ph_no',
        date_first_profession = '$date_first_profession',
        date_final_profession = '$date_final_profession',
        date_begin_service = '$date_begin_service',
        date_retire = '$date_retire',
        position = '$position',
        tdate = '$tdate',
        dod = '$dod'
        WHERE user_id = $user_id";

    // Update tbl_personaldata
    $updatePersonalDataQuery = "UPDATE tbl_personaldata SET 
        blood_grp = '$blood_grp',
        illness_history = '$illness_history',
        surgery_history = '$surgery_history',
        long_term_treatment = '$long_term_treatment',
        present_health = '$present_health',
        talents = '$talents',
        motto_principles = '$motto_principles'
        WHERE user_id = $user_id";

    // Execute update queries
    if ($conn->query($updateUserDetailsQuery) === TRUE && $conn->query($updatePersonalDataQuery) === TRUE) {
        // file_put_contents($log_file, "User details and personal data updated successfully\n", FILE_APPEND);
        echo "Record updated successfully";
    } else {
        throw new Exception("Error updating record: " . $conn->error);
    }

    // Commit transaction
    $conn->commit();
} catch (Exception $e) {
    // Rollback transaction on error
    $conn->rollback();
    // file_put_contents($log_file, $e->getMessage() . "\n", FILE_APPEND);
    echo $e->getMessage();
    exit;
}

// Fetch existing diary entries for the user
$existingDiaryEntriesQuery = "SELECT entry_id FROM tbl_diary_entries WHERE user_id = $user_id";
$existingDiaryEntriesResult = $conn->query($existingDiaryEntriesQuery);

$existingDiaryEntries = [];
while ($row = $existingDiaryEntriesResult->fetch_assoc()) {
    $existingDiaryEntries[] = $row['entry_id'];
}
// file_put_contents($log_file, "Fetched existing diary entries\n", FILE_APPEND);

// Collect entry_ids from post data
$postedDiaryEntries = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'DiaryEntry') === 0) {
        if (isset($value['entry_id']) && $value['entry_id'] !== null) {
            $postedDiaryEntries[] = $value['entry_id'];
        }
    }
}

// Find entry_ids to delete
$diaryEntriesToDelete = array_diff($existingDiaryEntries, $postedDiaryEntries);

if (!empty($diaryEntriesToDelete)) {
    $deleteDiaryEntriesQuery = "DELETE FROM tbl_diary_entries WHERE entry_id IN (" . implode(',', $diaryEntriesToDelete) . ")";
    if ($conn->query($deleteDiaryEntriesQuery) !== TRUE) {
        $error = "Error deleting diary entries: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old diary entries\n", FILE_APPEND);
}

// Insert or update diary entries
foreach ($data as $key => $value) {
    if (strpos($key, 'DiaryEntry') === 0) {
        $entry_id = $value['entry_id'];
        $title = $value['title'];
        $date = $value['date'];
        $text = $value['text'];

        if ($entry_id === null || $entry_id === "") {
            // Insert new diary entry
            $insertDiaryEntryQuery = "INSERT INTO tbl_diary_entries (user_id, entry_title, entry_date, entry_text) VALUES 
                ($user_id, '$title', '$date', '$text')";

            if ($conn->query($insertDiaryEntryQuery) !== TRUE) {
                $error = "Error inserting new diary entry: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new diary entry\n", FILE_APPEND);
        } else {
            // Update existing diary entry
            $updateDiaryEntryQuery = "UPDATE tbl_diary_entries SET 
                entry_title = '$title',
                entry_date = '$date',
                entry_text = '$text'
                WHERE entry_id = $entry_id";

            if ($conn->query($updateDiaryEntryQuery) !== TRUE) {
                $error = "Error updating diary entry ID $entry_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated diary entry ID $entry_id\n", FILE_APPEND);
        }
    }
}


// Fetch existing accreditations for the user
$existingAccreditQuery = "SELECT acc_id FROM tbl_accredit WHERE user_id = $user_id";
$existingAccreditResult = $conn->query($existingAccreditQuery);

if (!$existingAccreditResult) {
    $error = "Error fetching existing accreditations: " . $conn->error;
    // file_put_contents($log_file, "$error\n", FILE_APPEND);
    echo $error;
    exit;
}

$existingAccredits = [];
while ($row = $existingAccreditResult->fetch_assoc()) {
    $existingAccredits[] = $row['acc_id'];
}
// file_put_contents($log_file, "Fetched existing accreditations: " . print_r($existingAccredits, true) . "\n", FILE_APPEND);

// Collect acc_ids from post data
$postedAccreds = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Formation') === 0) {
        if (isset($value['acc_id']) && $value['acc_id'] !== null) {
            $postedAccreds[] = intval($value['acc_id']);
        }
    }
}
// file_put_contents($log_file, "Posted accreditations: " . print_r($postedAccreds, true) . "\n", FILE_APPEND);

// Find acc_ids to delete
$accreditsToDelete = array_diff($existingAccredits, $postedAccreds);

if (!empty($accreditsToDelete)) {
    $deleteAccreditsQuery = "DELETE FROM tbl_accredit WHERE acc_id IN (" . implode(',', $accreditsToDelete) . ")";
    if ($conn->query($deleteAccreditsQuery) !== TRUE) {
        $error = "Error deleting accreditations: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted accreditations: " . implode(',', $accreditsToDelete) . "\n", FILE_APPEND);
}

// Insert or update accreditations
foreach ($data as $key => $value) {
    if (strpos($key, 'Formation') === 0) {
        $acc_id = intval($value['acc_id']);
        $title = $value['title'];
        $acc_from = $value['acc_from'];
        $acc_to = $value['acc_to'];
        $acc_at = $value['acc_at'];
        $place = $value['place'];
        $directress = $value['directress']; // Add directress

        if ($acc_id === 0) {
            // Insert new accreditation
            $insertAccreditQuery = "INSERT INTO tbl_accredit (user_id, title, acc_from, acc_to, acc_at, place, directress) VALUES 
                ($user_id, '$title', '$acc_from', '$acc_to', '$acc_at', '$place', '$directress')";

            if ($conn->query($insertAccreditQuery) !== TRUE) {
                $error = "Error inserting new accreditation: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new accreditation with title '$title'\n", FILE_APPEND);
        } else {
            // Update existing accreditation
            $updateAccreditQuery = "UPDATE tbl_accredit SET 
                title = '$title',
                acc_from = '$acc_from',
                acc_to = '$acc_to',
                acc_at = '$acc_at',
                place = '$place',
                directress = '$directress' 
                WHERE acc_id = $acc_id";

            if ($conn->query($updateAccreditQuery) !== TRUE) {
                $error = "Error updating accreditation ID $acc_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated accreditation ID $acc_id\n", FILE_APPEND);
        }
    }
}

// file_put_contents($log_file, "Process completed\n", FILE_APPEND);


// Function to escape single quotes
function escapeSingleQuotes($string)
{
    return str_replace("'", "''", $string);
}

// Fetch existing user school details
$existingUserSchoolQuery = "SELECT school_id FROM tbl_user_school WHERE user_id = $user_id";
$existingUserSchoolResult = $conn->query($existingUserSchoolQuery);

$existingUserSchools = [];
while ($row = $existingUserSchoolResult->fetch_assoc()) {
    $existingUserSchools[] = $row['school_id'];
}
// file_put_contents($log_file, "Fetched existing user school details\n", FILE_APPEND);

// Collect school_ids from post data
$postedSchools = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'School') === 0) {
        if (isset($value['school_id']) && $value['school_id'] !== null) {
            $postedSchools[] = $value['school_id'];
        }
    }
}
// file_put_contents($log_file, "Collected school_ids from post data\n", FILE_APPEND);

// Add logging before the array_diff operation
// file_put_contents($log_file, "Existing user schools: " . implode(', ', $existingUserSchools) . "\n", FILE_APPEND);
// file_put_contents($log_file, "Posted school IDs: " . implode(', ', $postedSchools) . "\n", FILE_APPEND);

// Find school_ids to delete
try {
    $schoolsToDelete = array_diff($existingUserSchools, $postedSchools);

    // file_put_contents($log_file, "Schools to delete: " . implode(', ', $schoolsToDelete) . "\n", FILE_APPEND);

    if (!empty($schoolsToDelete)) {
        $deleteSchoolsQuery = "DELETE FROM tbl_user_school WHERE school_id IN (" . implode(',', $schoolsToDelete) . ")";
        // file_put_contents($log_file, "Delete schools query: $deleteSchoolsQuery\n", FILE_APPEND);
        if ($conn->query($deleteSchoolsQuery) !== TRUE) {
            throw new Exception("Error deleting user school details: " . $conn->error);
        }
        // file_put_contents($log_file, "Deleted old user school details\n", FILE_APPEND);
    } else {
        // file_put_contents($log_file, "No schools to delete\n", FILE_APPEND);
    }
} catch (Exception $e) {
    // file_put_contents($log_file, "Error: " . $e->getMessage() . "\n", FILE_APPEND);
    echo $e->getMessage();
    exit;
}

// Log the contents of the $data array before the loop
// file_put_contents($log_file, "Data array contents: " . print_r($data, true) . "\n", FILE_APPEND);

// Insert or update user school details
foreach ($data as $key => $value) {
    if (strpos($key, 'School') === 0 && is_array($value)) {
        $school_id = $value['school_id'];
        $class = $value['class'];
        $marks_percentage = $value['marks_percentage'];
        $university = $value['university'];
        $school_address = $value['school_address'];
        $year_of_passout = $value['year_of_passout'];

        try {
            if ($school_id === null) {
                // Insert school details query
                $insertSchoolDetailsQuery = "INSERT INTO tbl_user_school (user_id, class, marks_percentage, university, school_address, year_of_passout) VALUES 
                ($user_id, '" . escapeSingleQuotes($class) . "', '" . escapeSingleQuotes($marks_percentage) . "', '" . escapeSingleQuotes($university) . "', '" . escapeSingleQuotes($school_address) . "', '" . escapeSingleQuotes($year_of_passout) . "')";
                // file_put_contents($log_file, "Insert school details query: $insertSchoolDetailsQuery\n", FILE_APPEND);

                if ($conn->query($insertSchoolDetailsQuery) !== TRUE) {
                    throw new Exception("Error inserting new school details: " . $conn->error);
                }
                // file_put_contents($log_file, "Inserted new school details\n", FILE_APPEND);
            } else {
                // Update school details query
                $updateSchoolDetailsQuery = "UPDATE tbl_user_school SET 
                class = '" . escapeSingleQuotes($class) . "',
                marks_percentage = '" . escapeSingleQuotes($marks_percentage) . "',
                university = '" . escapeSingleQuotes($university) . "',
                school_address = '" . escapeSingleQuotes($school_address) . "',
                year_of_passout = '" . escapeSingleQuotes($year_of_passout) . "'
                WHERE school_id = $school_id AND user_id = $user_id";
                // file_put_contents($log_file, "Update school details query: $updateSchoolDetailsQuery\n", FILE_APPEND);

                if ($conn->query($updateSchoolDetailsQuery) !== TRUE) {
                    throw new Exception("Error updating school details ID $school_id: " . $conn->error);
                }
                // file_put_contents($log_file, "Updated school details ID $school_id\n", FILE_APPEND);
            }
        } catch (Exception $e) {
            // file_put_contents($log_file, "Error: " . $e->getMessage() . "\n", FILE_APPEND);
            echo $e->getMessage();
            exit;
        }
    }
}

// Fetch existing plus two details
$existingPlusTwoQuery = "SELECT plus_two_id FROM tbl_plus_two WHERE user_id = $user_id";
$existingPlusTwoResult = $conn->query($existingPlusTwoQuery);

$existingPlusTwoIds = [];
while ($row = $existingPlusTwoResult->fetch_assoc()) {
    $existingPlusTwoIds[] = $row['plus_two_id'];
}
// file_put_contents($log_file, "Fetched existing plus two details\n", FILE_APPEND);

// Collect plus_two_ids from post data
$postedPlusTwoIds = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Plus Two') === 0) {
        if (isset($value['plus_two_id']) && $value['plus_two_id'] !== null) {
            $postedPlusTwoIds[] = $value['plus_two_id'];
        }
    }
}
// file_put_contents($log_file, "Collected plus_two_ids from post data\n", FILE_APPEND);

// Add logging before the array_diff operation
// file_put_contents($log_file, "Existing plus two ids: " . implode(', ', $existingPlusTwoIds) . "\n", FILE_APPEND);
// file_put_contents($log_file, "Posted plus two IDs: " . implode(', ', $postedPlusTwoIds) . "\n", FILE_APPEND);

// Find plus_two_ids to delete
try {
    $plusTwoToDelete = array_diff($existingPlusTwoIds, $postedPlusTwoIds);

    // file_put_contents($log_file, "Plus two IDs to delete: " . implode(', ', $plusTwoToDelete) . "\n", FILE_APPEND);

    if (!empty($plusTwoToDelete)) {
        $deletePlusTwoQuery = "DELETE FROM tbl_plus_two WHERE plus_two_id IN (" . implode(',', $plusTwoToDelete) . ")";

        if ($conn->query($deletePlusTwoQuery) !== TRUE) {
            throw new Exception("Error deleting plus two details: " . $conn->error);
        }
        // file_put_contents($log_file, "Deleted old plus two details\n", FILE_APPEND);
    } else {
        // file_put_contents($log_file, "No plus two details to delete\n", FILE_APPEND);
    }
} catch (Exception $e) {
    // file_put_contents($log_file, "Error: " . $e->getMessage() . "\n", FILE_APPEND);
    echo $e->getMessage();
    exit;
}

// Insert or update plus two details
foreach ($data as $key => $value) {
    if (strpos($key, 'Plus Two') === 0 && is_array($value)) {
        $plus_two_id = $value['plus_two_id'];
        $stream = $value['stream/subject'];
        $marks = $value['marks'];
        $board_university = $value['board_university'];
        $year_of_passout = $value['year_of_passout'];
        $school_address = $value['school_address'];

        try {
            if ($plus_two_id === null) {
                // Insert plus two details query
                $insertPlusTwoQuery = "INSERT INTO tbl_plus_two (user_id, `stream/subject`, marks, board_university, year_of_passout, school_address) VALUES 
                ($user_id, '" . escapeSingleQuotes($stream) . "', '" . escapeSingleQuotes($marks) . "', '" . escapeSingleQuotes($board_university) . "', '" . escapeSingleQuotes($year_of_passout) . "', '" . escapeSingleQuotes($school_address) . "')";
                if ($conn->query($insertPlusTwoQuery) !== TRUE) {
                    throw new Exception("Error inserting new plus two details: " . $conn->error);
                }
                // file_put_contents($log_file, "Inserted new plus two details\n", FILE_APPEND);
            } else {
                // Update plus two details query
                $updatePlusTwoQuery = "UPDATE tbl_plus_two SET 
                `stream/subject` = '" . escapeSingleQuotes($stream) . "',
                marks = '" . escapeSingleQuotes($marks) . "',
                board_university = '" . escapeSingleQuotes($board_university) . "',
                year_of_passout = '" . escapeSingleQuotes($year_of_passout) . "',
                school_address = '" . escapeSingleQuotes($school_address) . "'
                WHERE plus_two_id = $plus_two_id AND user_id = $user_id";
                if ($conn->query($updatePlusTwoQuery) !== TRUE) {
                    throw new Exception("Error updating plus two details ID $plus_two_id: " . $conn->error);
                }
                // file_put_contents($log_file, "Updated plus two details ID $plus_two_id\n", FILE_APPEND);
            }
        } catch (Exception $e) {
            // file_put_contents($log_file, "Error: " . $e->getMessage() . "\n", FILE_APPEND);
            echo $e->getMessage();
            exit;
        }
    }
}

// Fetch existing UG details
$existingUgQuery = "SELECT user_ud_id FROM tbl_ugrad WHERE user_id = $user_id";
$existingUgResult = $conn->query($existingUgQuery);

$existingUgIds = [];
while ($row = $existingUgResult->fetch_assoc()) {
    $existingUgIds[] = $row['user_ud_id'];
}

// Collect user_ud_ids from post data
$postedUgIds = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'UG') === 0) {
        if (isset($value['user_ud_id']) && $value['user_ud_id'] !== null) {
            $postedUgIds[] = $value['user_ud_id'];
        }
    }
}

// Find user_ud_ids to delete
try {
    $ugToDelete = array_diff($existingUgIds, $postedUgIds);

    if (!empty($ugToDelete)) {
        $deleteUgQuery = "DELETE FROM tbl_ugrad WHERE user_ud_id IN (" . implode(',', $ugToDelete) . ")";

        if ($conn->query($deleteUgQuery) !== TRUE) {
            throw new Exception("Error deleting UG details: " . $conn->error);
        }
    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

// Insert or update UG details
foreach ($data as $key => $value) {
    if (strpos($key, 'UG') === 0 && is_array($value)) {
        $user_ud_id = $value['user_ud_id'];
        $degree = $value['degree'];
        $subject = $value['subject'];
        $mark = $value['mark'];
        $board_university = $value['board_university'];
        $year_of_passout = $value['year_of_passout'];
        $col_name_address = $value['col_name_address'];

        try {
            if ($user_ud_id === null) {
                // Insert UG details query
                $insertUgQuery = "INSERT INTO tbl_ugrad (user_id, degree, subject, mark, board_university, year_of_passout, col_name_address) VALUES 
                ($user_id, '" . escapeSingleQuotes($degree) . "', '" . escapeSingleQuotes($subject) . "', '" . escapeSingleQuotes($mark) . "', '" . escapeSingleQuotes($board_university) . "', '" . escapeSingleQuotes($year_of_passout) . "', '" . escapeSingleQuotes($col_name_address) . "')";

                if ($conn->query($insertUgQuery) !== TRUE) {
                    throw new Exception("Error inserting new UG details: " . $conn->error);
                }
            } else {
                // Update UG details query
                $updateUgQuery = "UPDATE tbl_ugrad SET 
                degree = '" . escapeSingleQuotes($degree) . "',
                subject = '" . escapeSingleQuotes($subject) . "',
                mark = '" . escapeSingleQuotes($mark) . "',
                board_university = '" . escapeSingleQuotes($board_university) . "',
                year_of_passout = '" . escapeSingleQuotes($year_of_passout) . "',
                col_name_address = '" . escapeSingleQuotes($col_name_address) . "'
                WHERE user_ud_id = $user_ud_id AND user_id = $user_id";

                if ($conn->query($updateUgQuery) !== TRUE) {
                    throw new Exception("Error updating UG details ID $user_ud_id: " . $conn->error);
                }
            }
        } catch (Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }
}

// Fetch existing PG details
$existingPgQuery = "SELECT user_pg_id FROM tbl_pg WHERE user_id = $user_id";
$existingPgResult = $conn->query($existingPgQuery);

$existingPgIds = [];
while ($row = $existingPgResult->fetch_assoc()) {
    $existingPgIds[] = $row['user_pg_id'];
}

// Collect user_pg_ids from post data
$postedPgIds = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'PG') === 0) {
        if (isset($value['user_pg_id']) && $value['user_pg_id'] !== null) {
            $postedPgIds[] = $value['user_pg_id'];
        }
    }
}

// Find user_pg_ids to delete
try {
    $pgToDelete = array_diff($existingPgIds, $postedPgIds);

    if (!empty($pgToDelete)) {
        $deletePgQuery = "DELETE FROM tbl_pg WHERE user_pg_id IN (" . implode(',', $pgToDelete) . ")";

        if ($conn->query($deletePgQuery) !== TRUE) {
            throw new Exception("Error deleting PG details: " . $conn->error);
        }
    }
} catch (Exception $e) {
    echo $e->getMessage();
    exit;
}

// Insert or update PG details
foreach ($data as $key => $value) {
    if (strpos($key, 'PG') === 0 && is_array($value)) {
        $user_pg_id = $value['user_pg_id'];
        $post_degree = $value['post_degree'];
        $subject = $value['subject'];
        $mark = $value['mark'];
        $board_university = $value['board_university'];
        $year_of_passout = $value['year_of_passout'];
        $col_name_address = $value['col_name_address'];

        try {
            if ($user_pg_id === null) {
                // Insert PG details query
                $insertPgQuery = "INSERT INTO tbl_pg (user_id, post_degree, subject, mark, board_university, year_of_passout, col_name_address) VALUES 
                    ($user_id, '" . escapeSingleQuotes($post_degree) . "', '" . escapeSingleQuotes($subject) . "', '" . escapeSingleQuotes($mark) . "', '" . escapeSingleQuotes($board_university) . "', '" . escapeSingleQuotes($year_of_passout) . "', '" . escapeSingleQuotes($col_name_address) . "')";
                if ($conn->query($insertPgQuery) !== TRUE) {
                    throw new Exception("Error inserting new PG details: " . $conn->error);
                }
            } else {
                // Update PG details query
                $updatePgQuery = "UPDATE tbl_pg SET 
                    post_degree = '" . escapeSingleQuotes($post_degree) . "',
                    subject = '" . escapeSingleQuotes($subject) . "',
                    mark = '" . escapeSingleQuotes($mark) . "',
                    board_university = '" . escapeSingleQuotes($board_university) . "',
                    year_of_passout = '" . escapeSingleQuotes($year_of_passout) . "',
                    col_name_address = '" . escapeSingleQuotes($col_name_address) . "'
                    WHERE user_pg_id = $user_pg_id AND user_id = $user_id";

                if ($conn->query($updatePgQuery) !== TRUE) {
                    throw new Exception("Error updating PG details ID $user_pg_id: " . $conn->error);
                }
            }
        } catch (Exception $e) {
            echo $e->getMessage();
            exit;
        }
    }
}

// Check if record exists for the user in tbl_family
$sqlCheckRecord = "SELECT COUNT(*) AS count FROM tbl_family WHERE user_id = $user_id";
$result = $conn->query($sqlCheckRecord);

if ($result && $result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $count = $row['count'];

    if ($count > 0) {
        // Record exists, perform update
        if (isset($data['Father Name 0'])) {
            $fatherName = escapeSingleQuotes($data['Father Name 0']);
            $dobFather = escapeSingleQuotes($data['Father DOB 0']);
            $dodFather = escapeSingleQuotes($data['Father DOD 0']);
            $fatherAddress = escapeSingleQuotes($data['Father Address 0']);
            $fatherOccupation = escapeSingleQuotes($data['Father Occupation 0']);
            $fatherParishDioceseNow = escapeSingleQuotes($data['Father Parish/Diocese Now 0']);
            $fatherParishDioceseBirth = escapeSingleQuotes($data['Father Parish/Diocese at Birth 0']);

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
                // file_put_contents($log_file, $message . "\n", FILE_APPEND);
            } else {
                $error_message = "Error updating Father's details: " . $conn->error;
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }
        } else {
            $error_message = "Error: Father's details not provided in JSON data";
            echo $error_message . "\n";
            // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }

        if (isset($data['Mother Name 0'])) {
            $motherName = escapeSingleQuotes($data['Mother Name 0']);
            $dobMother = escapeSingleQuotes($data['Mother DOB 0']);
            $dodMother = escapeSingleQuotes($data['Mother DOD 0']);
            $motherOccupation = escapeSingleQuotes($data['Mother Occupation 0']);

            $sqlUpdateMother = "UPDATE tbl_family SET
                                mother_name = '$motherName',
                                dob_mother = '$dobMother',
                                dod_mother = '$dodMother',
                                mother_occupation = '$motherOccupation'
                                WHERE user_id = $user_id";

            if ($conn->query($sqlUpdateMother) === TRUE) {
                $message = "Mother's details updated successfully";
                echo $message . "\n";
                // file_put_contents($log_file, $message . "\n", FILE_APPEND);
            } else {
                $error_message = "Error updating Mother's details: " . $conn->error;
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }
        } else {
            $error_message = "Error: Mother's details not provided in JSON data";
            echo $error_message . "\n";
            // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }

        if (isset($data['Guardian Name 0'])) {
            $guardianName = escapeSingleQuotes($data['Guardian Name 0']);
            $guardianAddressPhone = escapeSingleQuotes($data['Guardian Address/Phone 0']);
            $guardianRelation = escapeSingleQuotes($data['Guardian Relation 0']);

            $sqlUpdateGuardian = "UPDATE tbl_family SET
                                  guardian_name = '$guardianName',
                                  guardian_address_phone = '$guardianAddressPhone',
                                  guardian_relation = '$guardianRelation'
                                  WHERE user_id = $user_id";

            if ($conn->query($sqlUpdateGuardian) === TRUE) {
                $message = "Guardian's details updated successfully";
                echo $message . "\n";
                // file_put_contents($log_file, $message . "\n", FILE_APPEND);
            } else {
                $error_message = "Error updating Guardian's details: " . $conn->error;
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }
        } else {
            $error_message = "Error: Guardian's details not provided in JSON data";
            echo $error_message . "\n";
            // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }
    } else {
        // Record doesn't exist, perform insert followed by update
        $sqlInsert = "INSERT INTO tbl_family (user_id) VALUES ($user_id)";
        if ($conn->query($sqlInsert) === TRUE) {
            $message = "New record created successfully";
            echo $message . "\n";
            // file_put_contents($log_file, $message . "\n", FILE_APPEND);

            // Perform update after insertion
            if (isset($data['Father Name 0'])) {
                $fatherName = escapeSingleQuotes($data['Father Name 0']);
                $dobFather = escapeSingleQuotes($data['Father DOB 0']);
                $dodFather = escapeSingleQuotes($data['Father DOD 0']);
                $fatherAddress = escapeSingleQuotes($data['Father Address 0']);
                $fatherOccupation = escapeSingleQuotes($data['Father Occupation 0']);
                $fatherParishDioceseNow = escapeSingleQuotes($data['Father Parish/Diocese Now 0']);
                $fatherParishDioceseBirth = escapeSingleQuotes($data['Father Parish/Diocese at Birth 0']);

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
                    // file_put_contents($log_file, $message . "\n", FILE_APPEND);
                } else {
                    $error_message = "Error updating Father's details: " . $conn->error;
                    echo $error_message . "\n";
                    // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
                }
            } else {
                $error_message = "Error: Father's details not provided in JSON data";
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }

            if (isset($data['Mother Name 0'])) {
                $motherName = escapeSingleQuotes($data['Mother Name 0']);
                $dobMother = escapeSingleQuotes($data['Mother DOB 0']);
                $dodMother = escapeSingleQuotes($data['Mother DOD 0']);
                $motherOccupation = escapeSingleQuotes($data['Mother Occupation 0']);

                $sqlUpdateMother = "UPDATE tbl_family SET
                                    mother_name = '$motherName',
                                    dob_mother = '$dobMother',
                                    dod_mother = '$dodMother',
                                    mother_occupation = '$motherOccupation'
                                    WHERE user_id = $user_id";

                if ($conn->query($sqlUpdateMother) === TRUE) {
                    $message = "Mother's details updated successfully";
                    echo $message . "\n";
                    // file_put_contents($log_file, $message . "\n", FILE_APPEND);
                } else {
                    $error_message = "Error updating Mother's details: " . $conn->error;
                    echo $error_message . "\n";
                    // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
                }
            } else {
                $error_message = "Error: Mother's details not provided in JSON data";
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }

            if (isset($data['Guardian Name 0'])) {
                $guardianName = escapeSingleQuotes($data['Guardian Name 0']);
                $guardianAddressPhone = escapeSingleQuotes($data['Guardian Address/Phone 0']);
                $guardianRelation = escapeSingleQuotes($data['Guardian Relation 0']);

                $sqlUpdateGuardian = "UPDATE tbl_family SET
                                      guardian_name = '$guardianName',
                                      guardian_address_phone = '$guardianAddressPhone',
                                      guardian_relation = '$guardianRelation'
                                      WHERE user_id = $user_id";

                if ($conn->query($sqlUpdateGuardian) === TRUE) {
                    $message = "Guardian's details updated successfully";
                    echo $message . "\n";
                    // file_put_contents($log_file, $message . "\n", FILE_APPEND);
                } else {
                    $error_message = "Error updating Guardian's details: " . $conn->error;
                    echo $error_message . "\n";
                    // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
                }
            } else {
                $error_message = "Error: Guardian's details not provided in JSON data";
                echo $error_message . "\n";
                // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
            }
        } else {
            $error_message = "Error creating new record: " . $conn->error;
            echo $error_message . "\n";
            // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
        }
    }
} else {
    // Error querying database
    $error_message = "Error: Failed to check existing record";
    echo $error_message . "\n";
    // file_put_contents($log_file, $error_message . "\n", FILE_APPEND);
}

// Fetch existing siblings for the user
$existingSiblingQuery = "SELECT sib_id FROM tbl_sibling WHERE user_id = $user_id";
$existingSiblingResult = $conn->query($existingSiblingQuery);

$existingSiblings = [];
while ($row = $existingSiblingResult->fetch_assoc()) {
    $existingSiblings[] = $row['sib_id'];
}
// file_put_contents($log_file, "Fetched existing siblings\n", FILE_APPEND);

// Collect sib_ids from post data
$postedSiblings = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Sibling') === 0) {
        if (isset($value['sib_id']) && $value['sib_id'] !== null) {
            $postedSiblings[] = $value['sib_id'];
        }
    }
}

// Find sib_ids to delete
$siblingsToDelete = array_diff($existingSiblings, $postedSiblings);

if (!empty($siblingsToDelete)) {
    $deleteSiblingsQuery = "DELETE FROM tbl_sibling WHERE sib_id IN (" . implode(',', $siblingsToDelete) . ")";
    if ($conn->query($deleteSiblingsQuery) !== TRUE) {
        $error = "Error deleting siblings: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old siblings\n", FILE_APPEND);
}

// Insert or update siblings
foreach ($data as $key => $value) {
    if (strpos($key, 'Sibling') === 0) {
        $sib_id = $value['sib_id'];
        $sibling_name = $value['sibling_name'];
        $gender = $value['gender'];
        $dob = $value['dob'];
        $occupation = $value['occupation'];
        $address = $value['address'];
        $contact_no = $value['contact_no'];

        if ($sib_id === null) {
            // Insert new sibling
            $insertSiblingQuery = "INSERT INTO tbl_sibling (user_id, sibling_name, gender, dob, occupation, address, contact_no) VALUES 
                ($user_id, '$sibling_name', '$gender', '$dob', '$occupation', '$address', '$contact_no')";

            if ($conn->query($insertSiblingQuery) !== TRUE) {
                $error = "Error inserting new sibling: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new sibling\n", FILE_APPEND);
        } else {
            // Update existing sibling
            $updateSiblingQuery = "UPDATE tbl_sibling SET 
                sibling_name = '$sibling_name',
                gender = '$gender',
                dob = '$dob',
                occupation = '$occupation',
                address = '$address',
                contact_no = '$contact_no'
                WHERE sib_id = $sib_id";

            if ($conn->query($updateSiblingQuery) !== TRUE) {
                $error = "Error updating sibling ID $sib_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated sibling ID $sib_id\n", FILE_APPEND);
        }
    }
}

// Fetch existing pris for the user
$existingPrisQuery = "SELECT pris_id FROM tbl_pris WHERE user_id = $user_id";
$existingPrisResult = $conn->query($existingPrisQuery);

$existingPris = [];
while ($row = $existingPrisResult->fetch_assoc()) {
    $existingPris[] = $row['pris_id'];
}
// file_put_contents($log_file, "Fetched existing pris\n", FILE_APPEND);

// Collect pris_ids from post data
$postedPris = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Pris') === 0) {
        if (isset($value['pris_id']) && $value['pris_id'] !== null) {
            $postedPris[] = $value['pris_id'];
        }
    }
}

// Find pris_ids to delete
$prisToDelete = array_diff($existingPris, $postedPris);

if (!empty($prisToDelete)) {
    $deletePrisQuery = "DELETE FROM tbl_pris WHERE pris_id IN (" . implode(',', $prisToDelete) . ")";
    if ($conn->query($deletePrisQuery) !== TRUE) {
        $error = "Error deleting pris: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old pris\n", FILE_APPEND);
}

// Insert or update pris
foreach ($data as $key => $value) {
    if (strpos($key, 'Pris') === 0) {
        $pris_id = $value['pris_id'];
        $relative_name = $value['relative_name'];
        $address = $value['address'];
        $order = $value['order'];
        $relationship = $value['relationship'];

        if ($pris_id === null) {
            // Insert new pris
            $insertPrisQuery = "INSERT INTO tbl_pris (user_id, relative_name, address, `order`, relationship) VALUES 
                ($user_id, '$relative_name', '$address', '$order', '$relationship')";

            if ($conn->query($insertPrisQuery) !== TRUE) {
                $error = "Error inserting new pris: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new pris\n", FILE_APPEND);
        } else {
            // Update existing pris
            $updatePrisQuery = "UPDATE tbl_pris SET 
                relative_name = '$relative_name',
                address = '$address',
                `order` = '$order',
                relationship = '$relationship'
                WHERE pris_id = $pris_id";

            if ($conn->query($updatePrisQuery) !== TRUE) {
                $error = "Error updating pris ID $pris_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated pris ID $pris_id\n", FILE_APPEND);
        }
    }
}

// Fetch existing spers for the user
$existingSpersQuery = "SELECT spers_id FROM tbl_spers WHERE user_id = $user_id";
$existingSpersResult = $conn->query($existingSpersQuery);

$existingSpers = [];
while ($row = $existingSpersResult->fetch_assoc()) {
    $existingSpers[] = $row['spers_id'];
}
// file_put_contents($log_file, "Fetched existing spers\n", FILE_APPEND);

// Collect spers_ids from post data
$postedSpers = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Spers') === 0) {
        if (isset($value['spers_id']) && $value['spers_id'] !== null) {
            $postedSpers[] = $value['spers_id'];
        }
    }
}

// Find spers_ids to delete
$spersToDelete = array_diff($existingSpers, $postedSpers);

if (!empty($spersToDelete)) {
    $deleteSpersQuery = "DELETE FROM tbl_spers WHERE spers_id IN (" . implode(',', $spersToDelete) . ")";
    if ($conn->query($deleteSpersQuery) !== TRUE) {
        $error = "Error deleting spers: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old spers\n", FILE_APPEND);
}

// Insert or update spers
foreach ($data as $key => $value) {
    if (strpos($key, 'Spers') === 0) {
        $spers_id = $value['spers_id'];
        $rel_name = $value['rel_name'];
        $address = $value['address'];
        $contact_no = $value['contact_no'];

        if ($spers_id === null) {
            // Insert new spers
            $insertSpersQuery = "INSERT INTO tbl_spers (user_id, rel_name, address, contact_no) VALUES 
                ($user_id, '$rel_name', '$address', '$contact_no')";

            if ($conn->query($insertSpersQuery) !== TRUE) {
                $error = "Error inserting new spers: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new spers\n", FILE_APPEND);
        } else {
            // Update existing spers
            $updateSpersQuery = "UPDATE tbl_spers SET 
                rel_name = '$rel_name',
                address = '$address',
                contact_no = '$contact_no'
                WHERE spers_id = $spers_id";

            if ($conn->query($updateSpersQuery) !== TRUE) {
                $error = "Error updating spers ID $spers_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated spers ID $spers_id\n", FILE_APPEND);
        }
    }
}

// Fetch existing prof records for the user
$existingProfRecordQuery = "SELECT prof_id FROM tbl_prof_record WHERE user_id = $user_id";
$existingProfRecordResult = $conn->query($existingProfRecordQuery);

$existingProfRecords = [];
while ($row = $existingProfRecordResult->fetch_assoc()) {
    $existingProfRecords[] = $row['prof_id'];
}
// file_put_contents($log_file, "Fetched existing prof records\n", FILE_APPEND);

// Collect prof_ids from post data
$postedProfRecords = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Institution Name') === 0) {
        if (isset($value['prof_id']) && $value['prof_id'] !== null) {
            $postedProfRecords[] = $value['prof_id'];
        }
    }
}

// Find prof_ids to delete
$profRecordsToDelete = array_diff($existingProfRecords, $postedProfRecords);

if (!empty($profRecordsToDelete)) {
    $deleteProfRecordsQuery = "DELETE FROM tbl_prof_record WHERE prof_id IN (" . implode(',', $profRecordsToDelete) . ")";
    if ($conn->query($deleteProfRecordsQuery) !== TRUE) {
        $error = "Error deleting prof records: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old prof records\n", FILE_APPEND);
}

// Insert or update prof records
foreach ($data as $key => $value) {
    if (strpos($key, 'Institution Name') === 0) {
        $prof_id = $value['prof_id'];
        $insti_name = $value['insti_name'];
        $designation = $value['designation'];
        $joindate = $value['joindate'];
        $no_of_years = $value['no_of_years'];
        $retire_status = $value['retire_status'];

        if ($prof_id === null) {
            // Insert new prof record
            $insertProfRecordQuery = "INSERT INTO tbl_prof_record (user_id, insti_name, designation, joindate, no_of_years, retire_status) VALUES 
                ($user_id, '$insti_name', '$designation', '$joindate', '$no_of_years', '$retire_status')";

            if ($conn->query($insertProfRecordQuery) !== TRUE) {
                $error = "Error inserting new prof record: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new prof record\n", FILE_APPEND);
        } else {
            // Update existing prof record
            $updateProfRecordQuery = "UPDATE tbl_prof_record SET 
                insti_name = '$insti_name',
                designation = '$designation',
                joindate = '$joindate',
                no_of_years = '$no_of_years',
                retire_status = '$retire_status'
                WHERE prof_id = $prof_id";

            if ($conn->query($updateProfRecordQuery) !== TRUE) {
                $error = "Error updating prof record ID $prof_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated prof record ID $prof_id\n", FILE_APPEND);
        }
    }
}

// Fetch existing mission records for the user
$existingMissionQuery = "SELECT mission_id FROM tbl_mission WHERE user_id = $user_id";
$existingMissionResult = $conn->query($existingMissionQuery);

$existingMissions = [];
while ($row = $existingMissionResult->fetch_assoc()) {
    $existingMissions[] = $row['mission_id'];
}
// file_put_contents($log_file, "Fetched existing missions\n", FILE_APPEND);

// Collect mission_ids from post data
$postedMissions = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Place') === 0) {
        if (isset($value['mission_id']) && $value['mission_id'] !== null) {
            $postedMissions[] = $value['mission_id'];
        }
    }
}

// Find mission_ids to delete
$missionsToDelete = array_diff($existingMissions, $postedMissions);

if (!empty($missionsToDelete)) {
    $deleteMissionsQuery = "DELETE FROM tbl_mission WHERE mission_id IN (" . implode(',', $missionsToDelete) . ")";
    if ($conn->query($deleteMissionsQuery) !== TRUE) {
        $error = "Error deleting missions: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old missions\n", FILE_APPEND);
}

// Insert or update missions
foreach ($data as $key => $value) {
    if (strpos($key, 'Place') === 0) {
        $mission_id = $value['mission_id'];
        $place = $value['place'];
        $duties_congre = $value['duties_congre'];
        $duties_apost = $value['duties_apost'];

        if ($mission_id === null) {
            // Insert new mission
            $insertMissionQuery = "INSERT INTO tbl_mission (user_id, place, duties_congre, duties_apost) VALUES 
                ($user_id, '$place', '$duties_congre', '$duties_apost')";

            if ($conn->query($insertMissionQuery) !== TRUE) {
                $error = "Error inserting new mission: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new mission\n", FILE_APPEND);
        } else {
            // Update existing mission
            $updateMissionQuery = "UPDATE tbl_mission SET 
                place = '$place',
                duties_congre = '$duties_congre',
                duties_apost = '$duties_apost'
                WHERE mission_id = $mission_id";

            if ($conn->query($updateMissionQuery) !== TRUE) {
                $error = "Error updating mission ID $mission_id: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Updated mission ID $mission_id\n", FILE_APPEND);
        }
    }
}


$conn->close();
