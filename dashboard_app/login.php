<?php 
 session_start();
 include "db.php";

 if(isset($_POST['username']) && isset($_POST['password'])){
    function validate($data){
        $data=trim($data);
        $data=stripslashes($data);
        $data=htmlspecialchars($data);
        return $data;
    }
 }

 $username = validate($_POST['username']);
 $pass = validate($_POST['password']);

 if(empty($username)){
    header("Location:login.php?error=Usernaem is required");
    exit();
 }
 else if(empty($pass)){
    header("Location:login.php?error=Password is required");
    exit();
 }

 $sql = "SELECT * FROM users WHERE username='$username' AND password='$pass'";

 $result = mysqli_query($db,$sql);

if(mysqli_num_rows($result) ===1){
    $row = mysqli_fetch_assoc($result);
    if($row['username'] ===$username && $row['password'] ===$pass){
        echo"Logged In Mister ".$username." With Success";
        $_SESSION['username'] = $row['username'];
        $_SESSION['name'] = $row['name'];
        $_SESSION['UserId'] = $row['UserId'];
        header("Location:list.php");
        exit();
    }
    else{
        header("Location:login.php?error=Incorrect username or password");
        exit();
    }
}
else{
    header("Location: login.php");
    exit();
}