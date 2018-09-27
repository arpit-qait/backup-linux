<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<!-- TO ADD BASELINE TEST NUMBER -->

<%
	String baselineLoadTestNumber = "";
	String currLoadTestNumber     = (String)session.getAttribute("name");
	String currLoadTestDuration   = (String)session.getAttribute("testValue");
	    baselineLoadTestNumber = request.getParameter("baselineLoadTestNumber");
		String currDir = (String)session.getAttribute("currDir");
		String desiredFolder = currLoadTestNumber+"_"+currLoadTestDuration;
		FileWriter baselineFileWriter = new FileWriter(currDir +"/"+desiredFolder+"/BaselineTestNum.txt",true);
		
%>		<!-- IF BASELINETESTNUM.TXT IS PRESENT THEN BASELINE IS ALREADY ADDED, ELSE CREATING A NEW TXT FILE --> <%

		baselineFileWriter.write(baselineLoadTestNumber);
		baselineFileWriter.close();
%>
<div class="jumbotron text-center">
	<h3>Baseline test number successfully added!!! Refresh page to see the results!!!</h3>
</div>
