<?php
include '../connection.php';
// Include the dompdf library
require_once '../vendor/autoload.php';

$user_id = $_GET['user_id'];
$data = [];

// Function to execute query and fetch data
function fetchData($conn, $sqlQuery, $key, &$data, $singleRecord = true)
{
    $result = $conn->query($sqlQuery);
    if ($result) {
        if ($result->num_rows > 0) {
            if ($singleRecord) {
                $data[$key] = $result->fetch_assoc();
            } else {
                $data[$key] = [];
                while ($row = $result->fetch_assoc()) {
                    $data[$key][] = $row;
                }
            }
        }
    } else {
        echo "Error: " . $conn->error;
    }
}

// Fetch data from tbl_user_details
$sqlQuery = "SELECT user_name, official_name, baptism_name, pet_name, church_dob, school_dob, birth_place, baptism_place, 
                baptism_date, confirmation_date, confirmation_place, ph_no, date_first_profession, date_final_profession,
                date_begin_service, date_retire, position, tdate, dod
             FROM tbl_user_details
             WHERE user_id = $user_id";
fetchData($conn, $sqlQuery, 'user_details', $data);

// Fetch data from tbl_personaldata
$sqlQueryPersonalData = "SELECT blood_grp, illness_history, surgery_history, long_term_treatment,
                        present_health, talents, motto_principles
                        FROM tbl_personaldata
                        WHERE user_id = $user_id";
fetchData($conn, $sqlQueryPersonalData, 'personal_data', $data, false);

// Fetch data from tbl_accredit
$sqlQueryAccredit = "SELECT acc_id, title, acc_from, acc_to, acc_at, place
                    FROM tbl_accredit
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryAccredit, 'accredit', $data, false);

// Fetch data from tbl_user_school
$sqlQueryUserSchool = "SELECT school_id, class, marks_percentage, university, school_address, year_of_passout
                        FROM tbl_user_school
                        WHERE user_id = $user_id";
fetchData($conn, $sqlQueryUserSchool, 'user_school', $data, false);

// Fetch data from tbl_plus_two
$sqlQueryPlusTwo = "SELECT plus_two_id, `stream/subject`, marks, board_university, year_of_passout, school_address, residence
                    FROM tbl_plus_two
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryPlusTwo, 'plus_two', $data, false);

// Fetch data from tbl_ugrad
$sqlQueryUgrad = "SELECT user_ud_id, degree, subject, mark, board_university, year_of_passout, col_name_address, residence
                    FROM tbl_ugrad
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryUgrad, 'ugrad', $data, false);

// Fetch data from tbl_pg
$sqlQueryPg = "SELECT user_pg_id, post_degree, subject, mark, board_university, year_of_passout, col_name_address, residence
                FROM tbl_pg
                WHERE user_id = $user_id";
fetchData($conn, $sqlQueryPg, 'pg', $data, false);

// Fetch data from tbl_family
$sqlQueryFamily = "SELECT father_name, dob_father, dod_father, father_address, father_occupation, father_parish_diocese_now,
                    father_parish_diocese_birth, mother_name, dob_mother, dod_mother, mother_occupation,
                    guardian_name, guardian_address_phone, guardian_relation
                    FROM tbl_family
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryFamily, 'family', $data, false);

// Fetch data from tbl_sibling
$sqlQuerySibling = "SELECT sib_id, sibling_name, gender, dob, occupation, address, contact_no
                    FROM tbl_sibling
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQuerySibling, 'siblings', $data, false);

// Fetch data from tbl_pris
$sqlQueryPris = "SELECT pris_id, relative_name, address, `order`, relationship
                FROM tbl_pris
                WHERE user_id = $user_id";
fetchData($conn, $sqlQueryPris, 'pris', $data, false);

// Fetch data from tbl_spers
$sqlQuerySpers = "SELECT spers_id, rel_name, address, contact_no
                FROM tbl_spers
                WHERE user_id = $user_id";
fetchData($conn, $sqlQuerySpers, 'spers', $data, false);

// Fetch data from tbl_prof_record
$sqlQueryProfRecord = "SELECT prof_id, insti_name, designation, joindate, no_of_years, retire_status
                    FROM tbl_prof_record
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryProfRecord, 'prof_record', $data, false);

// Fetch data from tbl_mission
$sqlQueryMission = "SELECT mission_id, place, duties_congre, duties_apost
                    FROM tbl_mission
                    WHERE user_id = $user_id";
fetchData($conn, $sqlQueryMission, 'mission', $data, false);

// Return the data
header('Content-Type: application/json');
echo json_encode($data);

$conn->close();
