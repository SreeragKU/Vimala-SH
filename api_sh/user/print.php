<?php
include '../connection.php';
// Output the PDF using dompdf
require_once '../vendor/autoload.php';

use Dompdf\Dompdf;
use Dompdf\Options;

try {
    ob_start();

    $user_id = $_GET['user_id'];
    // Fetch data from tbl_user_details
    $sqlQuery = "SELECT user_name, official_name, baptism_name, pet_name, church_dob, school_dob, birth_place, baptism_place, 
                    baptism_date, confirmation_date, confirmation_place, img_url, ph_no, date_first_profession, date_final_profession,
                    date_begin_service, date_retire, position, tdate, dod
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

        echo '<h1 style="text-align: center">User Details</h1>';
        echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
        foreach ($row as $key => $value) {
            if ($value !== '' && $value !== null && $key !== 'img_url') {
                $label = ucwords(str_replace('_', ' ', $key));
                echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
            }
        }
        echo '</table>';
        echo '</pre>';

        // Fetch data from tbl_personaldata
        $sqlQueryPersonalData = "SELECT history_url, blood_grp, illness_history, surgery_history, long_term_treatment,
                                present_health, talents, handwriting_url, motto_principles
                                FROM tbl_personaldata
                                WHERE user_id = $user_id";
        $resultPersonalData = $conn->query($sqlQueryPersonalData);
        if ($resultPersonalData->num_rows > 0) {
            echo '<h1 style="text-align: center">Personal Data</h1>';
            while ($rowPersonalData = $resultPersonalData->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowPersonalData as $key => $value) {
                    if ($value !== '' && $value !== null && $key !== 'history_url' && $key !== 'handwriting_url') {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No personal data found.';
        }

        // Fetch data from tbl_accredit
        $sqlQueryAccredit = "SELECT title, acc_from, acc_to, acc_at, place
                            FROM tbl_accredit
                            WHERE user_id = $user_id";
        $resultAccredit = $conn->query($sqlQueryAccredit);
        if ($resultAccredit->num_rows > 0) {
            echo '<h1 style="text-align: center">Formation details</h1>';
            echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse; border: 1px solid black;">';
            echo '<tr>';
            echo '<th>Title</th>';
            echo '<th>Acc From</th>';
            echo '<th>Acc To</th>';
            echo '<th>Acc At</th>';
            echo '<th>Place</th>';
            echo '</tr>';
            while ($rowAccredit = $resultAccredit->fetch_assoc()) {
                echo '<tr>';
                foreach ($rowAccredit as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        echo '<td style="padding: 5px; text-align: center; border: 1px solid black;">' . $value . '</td>';
                    }
                }
                echo '</tr>';
            }
            echo '</table>';
        } else {
            echo '<br>No accredit data found.';
        }

        // Fetch data from tbl_user_school
        $sqlQueryUserSchool = "SELECT class, marks_percentage, university, school_address, year_of_passout
                                FROM tbl_user_school
                                WHERE user_id = $user_id";
        $resultUserSchool = $conn->query($sqlQueryUserSchool);
        if ($resultUserSchool->num_rows > 0) {
            echo '<h1 style="text-align: center">Eductaion Details</h1>';
            echo '<u><h3 style="text-align: left; margin-left: 80px;">School :</h3></u>';
            while ($rowUserSchool = $resultUserSchool->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowUserSchool as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No user school data found.';
        }

        // Fetch data from tbl_plus_two
        $sqlQueryPlusTwo = "SELECT `stream/subject`, marks, board_university, year_of_passout, school_address, residence
                            FROM tbl_plus_two
                            WHERE user_id = $user_id";
        $resultPlusTwo = $conn->query($sqlQueryPlusTwo);
        if ($resultPlusTwo->num_rows > 0) {
            echo '<u><h3 style="text-align: left; margin-left: 80px;">Plus Two :</h3></u>';
            while ($rowPlusTwo = $resultPlusTwo->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowPlusTwo as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No Plus Two data found.';
        }

        // Fetch data from tbl_ugrad
        $sqlQueryUgrad = "SELECT degree, subject, mark, board_university, year_of_passout, col_name_address, residence
                            FROM tbl_ugrad
                            WHERE user_id = $user_id";
        $resultUgrad = $conn->query($sqlQueryUgrad);
        if ($resultUgrad->num_rows > 0) {
            echo '<u><h3 style="text-align: left; margin-left: 80px;">Undergraduate :</h3></u>';
            while ($rowUgrad = $resultUgrad->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowUgrad as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No undergraduate data found.';
        }

        // Fetch data from tbl_pg
        $sqlQueryPg = "SELECT post_degree, subject, mark, board_university, year_of_passout, col_name_address, residence
                        FROM tbl_pg
                        WHERE user_id = $user_id";
        $resultPg = $conn->query($sqlQueryPg);
        if ($resultPg->num_rows > 0) {
            echo '<u><h3 style="text-align: left; margin-left: 80px;">Postgraduate :</h3></u>';
            while ($rowPg = $resultPg->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowPg as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No postgraduate data found.';
        }

        // Fetch data from tbl_family
        $sqlQueryFamily = "SELECT father_name, dob_father, dod_father, father_address, father_occupation, father_parish_diocese_now,
                            father_parish_diocese_birth, mother_name, dob_mother, dod_mother, mother_occupation,
                            guardian_name, guardian_address_phone, guardian_relation
                            FROM tbl_family
                            WHERE user_id = $user_id";
        $resultFamily = $conn->query($sqlQueryFamily);
        if ($resultFamily->num_rows > 0) {
            echo '<h1 style="text-align: center">Family Details</h1>';
            while ($rowFamily = $resultFamily->fetch_assoc()) {
                echo '<u><h3 style="text-align: left; margin-left: 80px;">Father :</h3></u>';
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowFamily as $key => $value) {
                    if ($value !== '' && $value !== null && strpos($key, 'father_') === 0) {
                        $label = ucwords(str_replace('_', ' ', substr($key, 7)));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';

                echo '<u><h3 style="text-align: left; margin-left: 80px;">Mother :</h3></u>';
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowFamily as $key => $value) {
                    if ($value !== '' && $value !== null && strpos($key, 'mother_') === 0) {
                        $label = ucwords(str_replace('_', ' ', substr($key, 7)));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';

                echo '<u><h3 style="text-align: left; margin-left: 80px;">Guardian :</h3></u>';
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowFamily as $key => $value) {
                    if ($value !== '' && $value !== null && strpos($key, 'guardian_') === 0) {
                        $label = ucwords(str_replace('_', ' ', substr($key, 9)));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No family data found.';
        }

        // Fetch data from tbl_sibling
        $sqlQuerySibling = "SELECT sibling_name, gender, dob, occupation, address, contact_no
                            FROM tbl_sibling
                            WHERE user_id = $user_id";
        $resultSibling = $conn->query($sqlQuerySibling);
        if ($resultSibling->num_rows > 0) {
            echo '<u><h3 style="text-align: left; margin-left: 80px;">Siblings :</h3></u>';
            while ($rowSibling = $resultSibling->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowSibling as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No sibling data found.';
        }

        // Fetch data from tbl_pris
        $sqlQueryPris = "SELECT relative_name, address, `order`, relationship
                FROM tbl_pris
                WHERE user_id = $user_id";
        $resultPris = $conn->query($sqlQueryPris);
        if ($resultPris->num_rows > 0) {
            echo '<h1 style="text-align: center">Related Personalities</h1>';
            while ($rowPris = $resultPris->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowPris as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No pris data found.';
        }

        // Fetch data from tbl_spers
        $sqlQuerySpers = "SELECT rel_name, address, contact_no
        FROM tbl_spers
        WHERE user_id = $user_id";
        $resultSpers = $conn->query($sqlQuerySpers);
        if ($resultSpers->num_rows > 0) {
            while ($rowSpers = $resultSpers->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowSpers as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No special person data found.';
        }

        // Fetch data from tbl_prof_record
        $sqlQueryProfRecord = "SELECT insti_name, designation, joindate, no_of_years, retire_status
                        FROM tbl_prof_record
                        WHERE user_id = $user_id";
        $resultProfRecord = $conn->query($sqlQueryProfRecord);
        if ($resultProfRecord->num_rows > 0) {
            echo '<h1 style="text-align: center">Prof Record </h1>';
            while ($rowProfRecord = $resultProfRecord->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowProfRecord as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No professional record data found.';
        }

        // Fetch data from tbl_prof_record
        $sqlQueryMission = "SELECT place, duties_congre, duties_apost
                    FROM tbl_mission
                    WHERE user_id = $user_id";
        $resultMission = $conn->query($sqlQueryMission);
        if ($resultMission->num_rows > 0) {
            echo '<h1 style="text-align: center">Mission Details</h1>';
            while ($rowMission = $resultMission->fetch_assoc()) {
                echo '<table style="margin: 20px auto; font-family: Arial, sans-serif; border-collapse: collapse;">';
                foreach ($rowMission as $key => $value) {
                    if ($value !== '' && $value !== null) {
                        $label = ucwords(str_replace('_', ' ', $key));
                        echo '<tr><td style="padding: 5px; text-align: left; font-weight: bold;">' . $label . ':</td><td style="padding: 5px; text-align: left">' . $value . '</td></tr>';
                    }
                }
                echo '</table>';
            }
        } else {
            echo '<br>No mission data found.';
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
