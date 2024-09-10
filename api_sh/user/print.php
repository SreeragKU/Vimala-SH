<?php
include '../connection.php';
require_once '../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

try {
    ob_start();

    $user_id = $_GET['user_id'];
    // Fetch data from tbl_user_details
    $sqlQuery = "SELECT user_name, official_name, baptism_name, pet_name, church_dob, school_dob, birth_place, baptism_place, 
    baptism_date, confirmation_date, confirmation_place, img_url, ph_no, date_first_profession, date_final_profession,
    date_begin_service, date_retire, position, dod
    FROM tbl_user_details
    WHERE user_id = $user_id";

    $result = $conn->query($sqlQuery);
    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        // Adjust the image URL
        $imgUrl = '../../' . $row['img_url'];

        if (file_exists($imgUrl)) {
            $imgData = file_get_contents($imgUrl);
            $imgDataUri = 'data:image/' . pathinfo($imgUrl, PATHINFO_EXTENSION) . ';base64,' . base64_encode($imgData);
            echo '<div style="display: flex; justify-content: center;">';
            echo '<center><img src="' . $imgDataUri . '" alt="User Image" style="border-radius: 50%; width: 300px; height: 370px; object-fit: contain;"></center>';
            echo '</div>';
        }

        echo '<h1 style="text-align: center">' . htmlspecialchars($row['user_name']) . '</h1>';
        echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
        foreach ($row as $key => $value) {
            if ($value !== '' && $value !== null && $key !== 'img_url' && $key !== 'user_name') {
                $label = ucwords(str_replace('_', ' ', $key));
                echo '<tr><td style="padding: 10px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 10px; text-align: left;">' . htmlspecialchars($value) . '</td></tr>';
            }
        }
        echo '</table>';

        // Fetch data from tbl_personaldata
        $sqlQueryPersonalData = "SELECT history_url, blood_grp, illness_history, surgery_history, long_term_treatment,
    present_health, talents, handwriting_url, motto_principles
    FROM tbl_personaldata
    WHERE user_id = $user_id";
        $resultPersonalData = $conn->query($sqlQueryPersonalData);

        if ($resultPersonalData->num_rows > 0) {
            echo '<h1 style="text-align: center">Personal Data</h1>';
            while ($rowPersonalData = $resultPersonalData->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
                foreach ($rowPersonalData as $key => $value) {
                    if ($value !== '' && $value !== null && $key !== 'history_url' && $key !== 'handwriting_url') {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 10px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 10px; text-align: left;">' . htmlspecialchars($value) . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        }


        // Fetch data from tbl_accredit
        $sqlQueryAccredit = "SELECT title, acc_from, acc_to, acc_at, place
FROM tbl_accredit
WHERE user_id = $user_id";
        $resultAccredit = $conn->query($sqlQueryAccredit);

        if ($resultAccredit->num_rows > 0) {
            echo '<h1 style="text-align: center">Formation Details</h1>';
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
            echo '<tr>';
            echo '<th style="padding: 10px; text-align: center;">Title</th>';
            echo '<th style="padding: 10px; text-align: center;">Acc From</th>';
            echo '<th style="padding: 10px; text-align: center;">Acc To</th>';
            echo '<th style="padding: 10px; text-align: center;">Acc At</th>';
            echo '<th style="padding: 10px; text-align: center;">Place</th>';
            echo '</tr>';

            while ($rowAccredit = $resultAccredit->fetch_assoc()) {
                echo '<tr>';
                foreach ($rowAccredit as $value) {
                    echo '<td style="padding: 10px; text-align: center;">' . ($value !== '' && $value !== null ? $value : 'N/A') . '</td>';
                }
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No accredit data found.';
        }


        // Fetch combined data from all tables
        $sqlQueryCombined = "
        SELECT 'School' AS level, class AS description, marks_percentage, university, school_address, year_of_passout
        FROM tbl_user_school
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Plus Two' AS level, `stream/subject` AS description, marks, board_university, school_address, year_of_passout
        FROM tbl_plus_two
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Undergraduate' AS level, degree AS description, mark, board_university, col_name_address, year_of_passout
        FROM tbl_ugrad
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Postgraduate' AS level, post_degree AS description, mark, board_university, col_name_address, year_of_passout
        FROM tbl_pg
        WHERE user_id = $user_id
        ";

        // Execute the query
        $resultCombined = $conn->query($sqlQueryCombined);

        echo '<h1 style="text-align: center">Education Details</h1>';
        if ($resultCombined->num_rows > 0) {
            echo '<table style="font-family: Arial, sans-serif; border-collapse: collapse; width: 100%;">';
            echo '<tr><th style="padding: 10px; text-align: left;">Level</th><th style="padding: 10px; text-align: left;">Description</th><th style="padding: 10px; text-align: left;">Marks/Grade</th><th style="padding: 10px; text-align: left;">University/Board</th><th style="padding: 10px; text-align: left;">Address</th><th style="padding: 10px; text-align: left;">Year of Passout</th></tr>';

            while ($row = $resultCombined->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 5px; text-align: left;">' . $row['level'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $row['description'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . ($row['marks'] ?? $row['marks_percentage'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . ($row['board_university'] ?? $row['university'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . ($row['school_address'] ?? $row['col_name_address'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $row['year_of_passout'] . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No educational data found.';
        }


        // Fetch data from tbl_family excluding parish columns
        $sqlQueryFamily = "
        SELECT 'Father' AS member_type, father_name AS name, dob_father AS dob, dod_father AS dod, father_address AS address, 
            father_occupation AS occupation, NULL AS contact_no
        FROM tbl_family
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Mother' AS member_type, mother_name AS name, dob_mother AS dob, dod_mother AS dod, NULL AS address, 
            mother_occupation AS occupation, NULL AS contact_no
        FROM tbl_family
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Guardian' AS member_type, guardian_name AS name, NULL AS dob, NULL AS dod, guardian_address_phone AS address, 
            NULL AS occupation, NULL AS contact_no
        FROM tbl_family
        WHERE user_id = $user_id
        UNION ALL
        SELECT 'Sibling' AS member_type, sibling_name AS name, dob AS dob, NULL AS dod, address, occupation, contact_no
        FROM tbl_sibling
        WHERE user_id = $user_id
        ";

        // Execute the query for the primary data
        $resultFamily = $conn->query($sqlQueryFamily);

        // Fetch parish data separately
        $sqlQueryParish = "
        SELECT 'Father' AS member_type, father_name AS name, father_parish_diocese_now AS parish_now, father_parish_diocese_birth AS parish_birth
        FROM tbl_family
        WHERE user_id = $user_id
        ";

        // Execute the query for the parish data
        $resultParish = $conn->query($sqlQueryParish);

        // Display primary family data
        echo '<h1 style="text-align: center">Family & Sibling Details</h1>';
        if ($resultFamily->num_rows > 0) {
            echo '<table style="font-family: Arial, sans-serif; border-collapse: collapse; width: 100%;">';
            echo '<tr>
                <th style="padding: 10px; text-align: left; width: 10%;">Relation</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Name</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Date of Birth</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Date of Death</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Address</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Occupation</th>
                <th style="padding: 10px; text-align: left; width: 10%;">Contact No</th>
            </tr>';

            while ($rowFamily = $resultFamily->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['member_type'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['name'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['dob'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['dod'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['address'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['occupation'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowFamily['contact_no'] . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No family or sibling data found.';
        }

        // Display parish data
        echo '<h1 style="text-align: center">Family Parish Details</h1>';
        if ($resultParish->num_rows > 0) {
            echo '<table style="font-family: Arial, sans-serif; border-collapse: collapse; width: 100%;">';
            echo '<tr>
                <th style="padding: 10px; text-align: left; width: 10%;">Relation</th>
                <th style="padding: 10px; text-align: left; width: 20%;">Name</th>
                <th style="padding: 10px; text-align: left; width: 35%;">Parish Now</th>
                <th style="padding: 10px; text-align: left; width: 35%;">Parish Birth</th>
            </tr>';

            while ($rowParish = $resultParish->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowParish['member_type'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowParish['name'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowParish['parish_now'] . '</td>';
                echo '<td style="padding: 5px; text-align: left;">' . $rowParish['parish_birth'] . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No parish data found.';
        }


        // Fetch data from tbl_pris and tbl_spers
        $sqlQueryContacts = "
            SELECT 'Priest/Sister' AS contact_type, relative_name AS name, address, `order` AS order_details, relationship, NULL AS contact_no
            FROM tbl_pris
            WHERE user_id = $user_id
            UNION ALL
            SELECT 'Emergency Contact' AS contact_type, rel_name AS name, address, NULL AS order_details, NULL AS relationship, contact_no
            FROM tbl_spers
            WHERE user_id = $user_id
        ";

        // Execute the query
        $resultContacts = $conn->query($sqlQueryContacts);

        if ($resultContacts->num_rows > 0) {
            echo '<h1 style="text-align: center">Contact Details</h1>';
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
            echo '<tr>';
            echo '<th style="padding: 10px; text-align: center;">Name</th>';
            echo '<th style="padding: 10px; text-align: center;">Address</th>';
            echo '<th style="padding: 10px; text-align: center;">Order/Details</th>';
            echo '<th style="padding: 10px; text-align: center;">Relationship</th>';
            echo '<th style="padding: 10px; text-align: center;">Contact No</th>';
            echo '</tr>';

            while ($rowContacts = $resultContacts->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 10px; text-align: center;">' . $rowContacts['name'] . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . $rowContacts['address'] . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowContacts['order_details'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowContacts['relationship'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowContacts['contact_no'] ?? 'N/A') . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No contact details found.';
        }


        // Fetch data from tbl_prof_record
        $sqlQueryProfRecord = "SELECT insti_name, designation, joindate, no_of_years, retire_status
                       FROM tbl_prof_record
                       WHERE user_id = $user_id";
        $resultProfRecord = $conn->query($sqlQueryProfRecord);

        if ($resultProfRecord->num_rows > 0) {
            echo '<h1 style="text-align: center">Professional Record</h1>';
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
            echo '<tr>';
            echo '<th style="padding: 10px; text-align: center;">Institution Name</th>';
            echo '<th style="padding: 10px; text-align: center;">Designation</th>';
            echo '<th style="padding: 10px; text-align: center;">Join Date</th>';
            echo '<th style="padding: 10px; text-align: center;">No. of Years</th>';
            echo '<th style="padding: 10px; text-align: center;">Retirement Status</th>';
            echo '</tr>';

            while ($rowProfRecord = $resultProfRecord->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowProfRecord['insti_name'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowProfRecord['designation'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowProfRecord['joindate'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowProfRecord['no_of_years'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowProfRecord['retire_status'] ?? 'N/A') . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No professional record data found.';
        }


        // Fetch data from tbl_mission
        $sqlQueryMission = "SELECT place, duties_congre, duties_apost
                    FROM tbl_mission
                    WHERE user_id = $user_id";
        $resultMission = $conn->query($sqlQueryMission);

        if ($resultMission->num_rows > 0) {
            echo '<h1 style="text-align: center">Convents and Missions</h1>';
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
            echo '<tr>';
            echo '<th style="padding: 10px; text-align: center;">Place</th>';
            echo '<th style="padding: 10px; text-align: center;">Duties Congregation</th>';
            echo '<th style="padding: 10px; text-align: center;">Duties Apostolate</th>';
            echo '</tr>';

            while ($rowMission = $resultMission->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowMission['place'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowMission['duties_congre'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowMission['duties_apost'] ?? 'N/A') . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No mission data found.';
        }

        // Fetch data from achievements table
        $sqlQueryAchievements = "SELECT title, sub_group, date, description FROM achievements WHERE user_id = $user_id";
        $resultAchievements = $conn->query($sqlQueryAchievements);

        // Add achievements section to the PDF
        echo '<h1 style="text-align: center">Achievements</h1>';
        if ($resultAchievements->num_rows > 0) {
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; width: 80%;">';
            echo '<tr>';
            echo '<th style="padding: 10px; text-align: center;">Achievement</th>';
            echo '<th style="padding: 10px; text-align: center;">Achieved for</th>';
            echo '<th style="padding: 10px; text-align: center;">Date</th>';
            echo '<th style="padding: 10px; text-align: center;">Description</th>';
            echo '</tr>';

            while ($rowAchievements = $resultAchievements->fetch_assoc()) {
                echo '<tr>';
                echo '<td style="padding: 10px;">' . ($rowAchievements['title'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px;">' . ($rowAchievements['sub_group'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px; text-align: center;">' . ($rowAchievements['date'] ?? 'N/A') . '</td>';
                echo '<td style="padding: 10px;">' . ($rowAchievements['description'] ?? 'N/A') . '</td>';
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No achievements data found.';
        }


        $html = ob_get_clean();

        try {
            $options = new Options();
            $options->set('isPhpEnabled', true);

            $dompdf = new Dompdf($options);
            $dompdf->loadHtml($html);

            // Set paper size and orientation
            $dompdf->setPaper('A4', 'portrait');

            // Render the HTML as PDF
            $dompdf->render();

            // Set Content-Type header
            header('Content-Type: application/pdf');

            // Output the generated PDF to Browser
            $dompdf->stream("user_details.pdf", array("Attachment" => false));
            exit();
        } catch (Exception $e) {
            error_log('An error occurred: ' . $e->getMessage());
            echo '<br>No user data found.';
        }
    } else {
        echo '<br>No user data found.';
    }
} catch (Exception $e) {
    echo 'An error occurred: ' . $e->getMessage();
}
?>

<style>
    .grid-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 20px;
        padding: 20px;
    }

    .grid-item {
        background-color: #f1f1f1;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .grid-item h3 {
        margin-top: 0;
    }

    .flex-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        gap: 10px;
        margin: 0 auto;
        max-width: 1200px;
        /* Adjust as needed */
    }

    .flex-item {
        flex: 1 1 calc(25% - 10px);
        /* Adjust percentage for the desired width, subtracting the gap */
        box-sizing: border-box;
        padding: 10px;
        background-color: #f4f4f4;
        border: 1px solid #ddd;
        border-radius: 5px;
        min-width: 250px;
        /* Ensure a minimum width for items */
    }

    .flex-item p {
        margin: 0 0 10px;
    }
</style>