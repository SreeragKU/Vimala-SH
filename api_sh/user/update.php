<?php
include '../connection.php';

// // Initialize log file
$log_file = __DIR__ . "/update_log_$user_id.txt";
file_put_contents($log_file, "Process started\n", FILE_APPEND);

// Get user ID from request
$user_id = $_GET['user_id'];

// Get JSON data from request body
$json_data = file_get_contents('php://input');

// Decode JSON data
$data = json_decode($json_data, true);
$file_path = __DIR__ . "/user_data_$user_id.json";
file_put_contents($file_path, $json_data);
file_put_contents($log_file, "Received JSON data and saved to file\n", FILE_APPEND);

// Check if user exists in tbl_user_details
$checkUserDetailsQuery = "SELECT * FROM tbl_user_details WHERE user_id = $user_id";
$userDetailsResult = $conn->query($checkUserDetailsQuery);
file_put_contents($log_file, "Checked tbl_user_details for user\n", FILE_APPEND);

// Check if user exists in tbl_personaldata
$checkPersonalDataQuery = "SELECT * FROM tbl_personaldata WHERE user_id = $user_id";
$personalDataResult = $conn->query($checkPersonalDataQuery);
// file_put_contents($log_file, "Checked tbl_personaldata for user\n", FILE_APPEND);

if ($userDetailsResult->num_rows == 0) {
    $insertUserDetailsQuery = "INSERT INTO tbl_user_details (user_id) VALUES ($user_id)";
    if ($conn->query($insertUserDetailsQuery) !== TRUE) {
        $error = "Error inserting user details: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Inserted new user details\n", FILE_APPEND);
}

if ($personalDataResult->num_rows == 0) {
    $insertPersonalDataQuery = "INSERT INTO tbl_personaldata (user_id) VALUES ($user_id)";
    if ($conn->query($insertPersonalDataQuery) !== TRUE) {
        $error = "Error inserting personal data: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Inserted new personal data\n", FILE_APPEND);
}

// Update tbl_user_details
$updateUserDetailsQuery = "UPDATE tbl_user_details SET 
    user_name = '{$data['Official Name']}',
    official_name = '{$data['Official Name']}',
    baptism_name = '{$data['Baptism Name']}',
    pet_name = '{$data['Pet Name']}',
    church_dob = '{$data['Church DOB']}',
    school_dob = '{$data['School DOB']}',
    birth_place = '{$data['Birth Place']}',
    baptism_place = '{$data['Baptism Place']}',
    baptism_date = '{$data['Baptism Date']}',
    confirmation_date = '{$data['Confirmation Date']}',
    confirmation_place = '{$data['Confirmation Place']}',
    ph_no = '{$data['Phone Number']}',
    date_first_profession = '{$data['Date of First Profession']}',
    date_final_profession = '{$data['Date of Final Profession']}',
    date_begin_service = '{$data['Date of Begin Service']}',
    date_retire = '{$data['Date of Retire']}',
    position = '{$data['Position']}',
    tdate = '{$data['Tdate']}',
    dod = '{$data['Date of Death']}'
    WHERE user_id = $user_id";

// Update tbl_personaldata
$updatePersonalDataQuery = "UPDATE tbl_personaldata SET 
    blood_grp = '{$data['Blood Group']}',
    illness_history = '{$data['Illness History']}',
    surgery_history = '{$data['Surgery History']}',
    long_term_treatment = '{$data['Long Term Treatment']}',
    present_health = '{$data['Present Health']}',
    talents = '{$data['Talents']}',
    motto_principles = '{$data['Motto Principles']}'
    WHERE user_id = $user_id";

// Execute update queries
if ($conn->query($updateUserDetailsQuery) === TRUE && $conn->query($updatePersonalDataQuery) === TRUE) {
    // file_put_contents($log_file, "User details and personal data updated successfully\n", FILE_APPEND);
    echo "Record updated successfully";
} else {
    $error = "Error updating record: " . $conn->error;
    // file_put_contents($log_file, "$error\n", FILE_APPEND);
    echo $error;
    exit;
}

// Fetch existing accreditations for the user
$existingAccreditQuery = "SELECT acc_id FROM tbl_accredit WHERE user_id = $user_id";
$existingAccreditResult = $conn->query($existingAccreditQuery);

$existingAccredits = [];
while ($row = $existingAccreditResult->fetch_assoc()) {
    $existingAccredits[] = $row['acc_id'];
}
// file_put_contents($log_file, "Fetched existing accreditations\n", FILE_APPEND);

// Collect acc_ids from post data
$postedAccredits = [];
foreach ($data as $key => $value) {
    if (strpos($key, 'Formation') === 0) {
        if (isset($value['acc_id']) && $value['acc_id'] !== null) {
            $postedAccredits[] = $value['acc_id'];
        }
    }
}

// Find acc_ids to delete
$accreditsToDelete = array_diff($existingAccredits, $postedAccredits);

if (!empty($accreditsToDelete)) {
    $deleteAccreditsQuery = "DELETE FROM tbl_accredit WHERE acc_id IN (" . implode(',', $accreditsToDelete) . ")";
    if ($conn->query($deleteAccreditsQuery) !== TRUE) {
        $error = "Error deleting accreditations: " . $conn->error;
        // file_put_contents($log_file, "$error\n", FILE_APPEND);
        echo $error;
        exit;
    }
    // file_put_contents($log_file, "Deleted old accreditations\n", FILE_APPEND);
}

// Insert or update accreditations
foreach ($data as $key => $value) {
    if (strpos($key, 'Formation') === 0) {
        $acc_id = $value['acc_id'];
        $title = $value['title'];
        $acc_from = $value['acc_from'];
        $acc_to = $value['acc_to'];
        $acc_at = $value['acc_at'];
        $place = $value['place'];

        if ($acc_id === null) {
            // Insert new accreditation
            $insertAccreditQuery = "INSERT INTO tbl_accredit (user_id, title, acc_from, acc_to, acc_at, place) VALUES 
                ($user_id, '$title', '$acc_from', '$acc_to', '$acc_at', '$place')";

            if ($conn->query($insertAccreditQuery) !== TRUE) {
                $error = "Error inserting new accreditation: " . $conn->error;
                // file_put_contents($log_file, "$error\n", FILE_APPEND);
                echo $error;
                exit;
            }
            // file_put_contents($log_file, "Inserted new accreditation\n", FILE_APPEND);
        } else {
            // Update existing accreditation
            $updateAccreditQuery = "UPDATE tbl_accredit SET 
                title = '$title',
                acc_from = '$acc_from',
                acc_to = '$acc_to',
                acc_at = '$acc_at',
                place = '$place'
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
                // Insert new school details
                $insertSchoolDetailsQuery = "INSERT INTO tbl_user_school (user_id, class, marks_percentage, university, school_address, year_of_passout) VALUES 
                    ($user_id, '$class', '$marks_percentage', '$university', '$school_address', '$year_of_passout')";
                // file_put_contents($log_file, "Insert school details query: $insertSchoolDetailsQuery\n", FILE_APPEND);

                if ($conn->query($insertSchoolDetailsQuery) !== TRUE) {
                    throw new Exception("Error inserting new school details: " . $conn->error);
                }
                // file_put_contents($log_file, "Inserted new school details\n", FILE_APPEND);
            } else {
                // Update existing school details
                $updateSchoolDetailsQuery = "UPDATE tbl_user_school SET 
                    class = '$class',
                    marks_percentage = '$marks_percentage',
                    university = '$university',
                    school_address = '$school_address',
                    year_of_passout = '$year_of_passout'
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
                // Insert new plus two details
                $insertPlusTwoQuery = "INSERT INTO tbl_plus_two (user_id, `stream/subject`, marks, board_university, year_of_passout, school_address) VALUES 
                    ($user_id, '$stream', '$marks', '$board_university', '$year_of_passout', '$school_address')";

                if ($conn->query($insertPlusTwoQuery) !== TRUE) {
                    throw new Exception("Error inserting new plus two details: " . $conn->error);
                }
                // file_put_contents($log_file, "Inserted new plus two details\n", FILE_APPEND);
            } else {
                // Update existing plus two details
                $updatePlusTwoQuery = "UPDATE tbl_plus_two SET 
                    `stream/subject` = '$stream',
                    marks = '$marks',
                    board_university = '$board_university',
                    year_of_passout = '$year_of_passout',
                    school_address = '$school_address'
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
                // Insert new UG details
                $insertUgQuery = "INSERT INTO tbl_ugrad (user_id, degree, subject, mark, board_university, year_of_passout, col_name_address) VALUES 
                    ($user_id, '$degree', '$subject', '$mark', '$board_university', '$year_of_passout', '$col_name_address')";

                if ($conn->query($insertUgQuery) !== TRUE) {
                    throw new Exception("Error inserting new UG details: " . $conn->error);
                }
            } else {
                // Update existing UG details
                $updateUgQuery = "UPDATE tbl_ugrad SET 
                    degree = '$degree',
                    subject = '$subject',
                    mark = '$mark',
                    board_university = '$board_university',
                    year_of_passout = '$year_of_passout',
                    col_name_address = '$col_name_address'
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
                // Insert new PG details
                $insertPgQuery = "INSERT INTO tbl_pg (user_id, post_degree, subject, mark, board_university, year_of_passout, col_name_address) VALUES 
                    ($user_id, '$post_degree', '$subject', '$mark', '$board_university', '$year_of_passout', '$col_name_address')";

                if ($conn->query($insertPgQuery) !== TRUE) {
                    throw new Exception("Error inserting new PG details: " . $conn->error);
                }
            } else {
                // Update existing PG details
                $updatePgQuery = "UPDATE tbl_pg SET 
                    post_degree = '$post_degree',
                    subject = '$subject',
                    mark = '$mark',
                    board_university = '$board_university',
                    year_of_passout = '$year_of_passout',
                    col_name_address = '$col_name_address'
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

// Close connection
$conn->close();


// file_put_contents($log_file, "Process completed and connection closed\n", FILE_APPEND);
