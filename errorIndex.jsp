<!DOCTYPE html>
<!-- Error Page - Automatically loaded incase of any error -->
<%@ page isErrorPage="true" %>
<%@ page errorPage="errorIndex.jsp" %>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" href="../../QAminiLogo.ico">

    <title>Gale Reports</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">

    <script>
	// Incase Of Unmatched testNumber, This page will be loaded and user needs to Enter testNumner Again

        var testNumber = prompt("Result not stored! Please try again!!!(eg. 2193)", "");
		if(testNumber!=null)
	// If valid testNumner input by user, home.jsp is loaded by providing testNumber as component
            window.location = "home_new_v2.jsp?currLoadTestNumber=" + encodeURIComponent(testNumber);
    </script>
</head>
</html>
