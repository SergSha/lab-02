<!DOCTYPE html>
<html>
<head>
<title>LIST CARS</title>
<meta charset="utf-8" />
</head>
<body>

<h2>LIST CARS</h2>

<?php
// List of new and used cars
try {
    $conn = new PDO("mysql:host={{ ip_address['data'] }};port=3306;dbname=cars", "user", "user1234");
    $tbs = "SHOW TABLES";
    $tbarray = $conn->query($tbs);
    while($tb = $tbarray->fetch()){
    echo "<h3>List " . $tb["0"] . " cars</h3>";
    echo "<table><tr><th>N</th><th>Name</th><th>Year</th><th>Price</th></tr>";
    $sql = "SELECT * FROM $tb[0]";
    $result = $conn->query($sql);
    $count = 1;
    while($row = $result->fetch()){
        echo "<tr>";
            echo "<td>" . $count . "</td>";
            echo "<td>" . $row["name"] . "</td>";
            echo "<td>" . $row["year"] . "</td>";
            echo "<td>" . $row["price"] . "</td>";
            //echo "<td><a href='update.php?tb=" . $tb["0"] . "&id=" . $row["id"] . "'>Edit</a></td>";
            echo "<td><form action='update.php' method='get'>
                <input type='hidden' name='tb' value='" . $tb["0"] . "' />
                <input type='hidden' name='id' value='" . $row["id"] . "' />
                <input type='submit' value='Edit...' />
                </form></td>";
            echo "<td><form action='delete.php' method='post'>
                <input type='hidden' name='tb' value='" . $tb["0"] . "' />
                <input type='hidden' name='id' value='" . $row["id"] . "' />
                <input type='submit' value='Delete'>
                </form></td>";
        echo "</tr>";
        $count++;
    }
    echo "</table>";
    }
}
catch (PDOException $e) {
    echo "Database error: " . $e->getMessage();
}
?>

<hr />

<h3>Add a car:</h3>
<form action="add.php" method="post">
    <p><label for="tb">New or used:</label>
    <select id="cars" name="tb">
    <option value="new">new</option>
    <option value="used">used</option>
    </select></p>
    <p>Name:
    <input type="text" name="name" /></p>
    <p>Year of manufacture:
    <input type="year" name="year" /></p>
    <p>Price:
    <input type="number" name="price" /></p>
    <input type="submit" value="Add" />
</form>

</body>
</html>
