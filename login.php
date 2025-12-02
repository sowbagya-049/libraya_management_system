<?php
session_start();
ob_start();  // Ensure no output is sent before headers
error_reporting(E_ALL);
ini_set('display_errors', 1);

$servername = "localhost";
$username = "root";
$password = "Sow@2005#18";
$dbname = "library_management";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT); // Enable detailed MySQLi error reporting

$conn = new mysqli($servername, $username, $password, $dbname);

// Check if the connection is successful
if ($conn->connect_error) {
    error_log("Database connection failed: " . $conn->connect_error);
    die("Database connection issue. Please try again later.");
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['username'], $_POST['password'])) {
        header("Location: login.html?error=" . urlencode("Please fill in all fields"));
        exit();
    }

    $user = trim($_POST['username']);
    $pass = trim($_POST['password']);

    if (empty($user) || empty($pass)) {
        header("Location: login.html?error=" . urlencode("Please fill in all fields"));
        exit();
    }

    $stmt = $conn->prepare("SELECT id, username, password, role FROM users WHERE username = ?");
    if (!$stmt) {
        die("Error in preparing statement: " . $conn->error);
    }

    $stmt->bind_param("s", $user);
    $stmt->execute();
    $result = $stmt->get_result();
    $user_data = $result->fetch_assoc();

    // Debugging output
    if (!$user_data) {
        error_log("User not found: $user");
        header("Location: index.html?error=" . urlencode("Invalid username or password"));
        exit();
    }

    // Debugging: Check retrieved password
    error_log("Stored Password Hash: " . $user_data['password']);
    error_log("Entered Password: " . $pass);

    if (password_verify($pass, $user_data['password'])) { 
        $_SESSION['username'] = $user_data['username'];
        $_SESSION['role'] = $user_data['role'];
        $_SESSION['user_id'] = $user_data['id']; 

        if ($user_data['role'] == 'admin') {
            header("Location: dashboard_admin.php");
        } else if ($user_data['role'] == 'student') {
            header("Location: dashboard_student.php");
        }
        exit();
    } else {
        error_log("Password mismatch for user: $user");
        header("Location: index.html?error=" . urlencode("Invalid username or password"));
        exit();
    }

    $stmt->close();
}

$conn->close();
ob_end_flush();  // Flush the output buffer
?>
