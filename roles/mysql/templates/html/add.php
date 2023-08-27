<?php
// Add a car to database
if (isset($_POST["tb"]) && isset($_POST["name"]) && isset($_POST["year"]) && isset($_POST["price"])) {
     
    $tb = $_POST["tb"];
    try {
        $conn = new PDO("mysql:host={{ ip_address['data'] }};port=3306;dbname=cars", "user", "user1234");
        $sql = "INSERT INTO $tb (name, year, price) VALUES (:name, :year, :price)";
        // определяем prepared statement
        $stmt = $conn->prepare($sql);
        // привязываем параметры к значениям
        //$stmt->bindValue(":tb", $_POST["tb"]);
        $stmt->bindValue(":name", $_POST["name"]);
        $stmt->bindValue(":year", $_POST["year"]);
        $stmt->bindValue(":price", $_POST["price"]);
        // выполняем prepared statement
        $affectedRowsNumber = $stmt->execute();
        // если добавлена как минимум одна строка
        //if($affectedRowsNumber > 0 ){
            //echo "Data successfully added: tb=" . $_POST["tb"] . "  name=" . $_POST["name"] . "  year=" . $_POST["year"] . "  price=" . $_POST["price"];
        //}
        //$conn = null;
        header("Location: index.php");
    }
    catch (PDOException $e) {
        echo "Database error: " . $e->getMessage();
    }
}
?>

