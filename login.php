<?php
    session_start();

    if (isset($_SERVER['HTTP_ORIGIN'])) {
        header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
        header("Access-Control-Allow-Credentials: true");
        header('Access-Control-Max-Age: 86400');    // cache for 1 day
    }

    // Access-Control headers are received during OPTIONS requests
    if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
            header("Access-Control-Allow-Methods: GET, POST, OPTIONS");        
        if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
            header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
        exit(0);
    }
    
    require "dbconnect.php";

    $data = file_get_contents("php://input");

    if (isset($data)) {
        $request = json_decode($data);
        $username = $request->username;
        $password = $request->password;
    }

    $username= mysqli_real_escape_string($con,$username);
    $password = mysqli_real_escape_string($con,$password);
    $username = stripslashes($username);
    $password = stripslashes($password);
    //-----------------------------------------------------------------
    
    $pwd_raw = $password;
    $pwd_hash = $pwd_raw;

    //------------------------------------------------------------------

    $sql = "SELECT * FROM user WHERE username = '$username' and password = '$pwd_hash'";

    $result = mysqli_query($con,$sql);
    $row_resident_info = mysqli_fetch_assoc($result);
    $row = mysqli_fetch_array($result,MYSQLI_ASSOC);
    
    $_SESSION['id'] = $row_resident_info['id'];
    $active = $row['active'];
    $count = mysqli_num_rows($result);

    // If result matched myusername and mypassword, table row must be 1 row                    
    if($count >0) {
        $response= array(
            "state"=>"Successful",
            "id"=>$row_resident_info['id'],
            "name"=>$row_resident_info['name'],
            "username"=>$row_resident_info['username'],
            "password"=>$row_resident_info['password'],
        );
    }else {
        $response= array("state"=>"Unsuccessful");         
    }
    echo json_encode($response);
    $con->close();