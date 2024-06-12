<?php
include '../connection.php';

$perPage = isset($_GET['perPage']) ? $_GET['perPage'] : 8;

// Get total number of entries
$totalQuery = "SELECT COUNT(*) AS total FROM tbl_user_details";
$totalResult = $conn->query($totalQuery);
$totalRows = $totalResult->fetch_assoc()['total'];

$page = isset($_GET['page']) ? $_GET['page'] : 1;
$offset = ($page - 1) * $perPage;

// Search query
$searchQuery = isset($_GET['query']) ? "WHERE official_name LIKE '%" . $conn->real_escape_string($_GET['query']) . "%'" : '';

// Sorting logic
$orderBy = 'STR_TO_DATE(date_first_profession, "%Y-%m-%d")';

$sqlQuery = "SELECT * FROM tbl_user_details $searchQuery ORDER BY $orderBy LIMIT $offset, $perPage";

$resultOfQuery = $conn->query($sqlQuery);

if ($resultOfQuery->num_rows > 0) {
    $memberData = array();
    while ($row = $resultOfQuery->fetch_assoc()) {
        $imageData = file_get_contents('../../' . $row['img_url']);
        $base64Image = base64_encode($imageData);
        $row['img_url'] = $base64Image;

        $memberData[] = $row;
    }

    // Calculate total pages
    $totalPages = ceil($totalRows / $perPage);

    echo json_encode(array(
        "success" => true,
        "totalPages" => $totalPages,
        "memberData" => $memberData,
    ));
} else {
    echo json_encode(array("success" => false, "message" => "No data found"));
}
