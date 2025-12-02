<?php
include 'config.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = trim($_POST['username']);
    $password = password_hash(trim($_POST['password']), PASSWORD_DEFAULT); 
    $role = trim($_POST['role']);

    // Check if username exists
    $check_user = $conn->prepare("SELECT id FROM users WHERE username = ?");
    $check_user->bind_param("s", $username);
    $check_user->execute();
    $check_user->store_result();

    if ($check_user->num_rows > 0) {
        header("Location: signup.html?error=" . urlencode("Username already exists"));
        exit();
    }
    $check_user->close();

    $conn->begin_transaction();
    
    try {
        if ($role == 'student') {
            $name = trim($_POST['name']);
            $course = trim($_POST['course']);
            $year = trim($_POST['year']);
            $branch = trim($_POST['branch']);
            $email = trim($_POST['email']);

            // Insert student details first
            $sql_student = "INSERT INTO students (name, course, year, branch, email) VALUES (?, ?, ?, ?, ?)";
            $stmt_student = $conn->prepare($sql_student);
            $stmt_student->bind_param("sssss", $name, $course, $year, $branch, $email);
            $stmt_student->execute();
            $student_id = $stmt_student->insert_id; // Get the student ID

            // Insert user with student_id
            $sql_user = "INSERT INTO users (username, password, role, student_id) VALUES (?, ?, ?, ?)";
            $stmt_user = $conn->prepare($sql_user);
            $stmt_user->bind_param("sssi", $username, $password, $role, $student_id);
            $stmt_user->execute();

            $conn->commit();

            header("Location: index.html?success=" . urlencode("Account created successfully"));
            exit();
        } else {
            // Insert user for non-students
            $sql = "INSERT INTO users (username, password, role) VALUES (?, ?, ?)";
            $stmt = $conn->prepare($sql);
            $stmt->bind_param("sss", $username, $password, $role);

            if ($stmt->execute()) {
                header("Location: index.html?success=" . urlencode("Account created successfully"));
                exit();
            } else {
                throw new Exception("User creation failed: " . $stmt->error);
            }
        }
    } catch (Exception $e) {
        $conn->rollback();
        error_log("Error: " . $e->getMessage());
        header("Location: signup.html?error=" . urlencode("Something went wrong. Please try again."));
        exit();
    } finally {
        if (isset($stmt_student)) $stmt_student->close();
        if (isset($stmt_user)) $stmt_user->close();
        if (isset($stmt)) $stmt->close();
        $conn->close();
    }
}
?>
