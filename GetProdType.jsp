<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<!--  Display list of All Products And Changing Product generates AJAX call to get Comparision Table Of Particular Product And BaseLine Product -->

<%
	String baselineLoadTestNumber = request.getParameter("baselineTest");
	String currLoadTestNumber     = request.getParameter("name");
	String currLoadTestDuration   = (String)session.getAttribute("testValue");
	String currDir 				  = (String)session.getAttribute("currDir");
%>
<html>
<body onload="getCompTable('<%=baselineLoadTestNumber%>','<%=currLoadTestNumber%>',"Overall");">

	<script>
	function getCompTable(baseTest,currTest,prodType) {
				xhttp = new XMLHttpRequest();
				xhttp.onreadystatechange = function() {
					if (this.readyState == 4 && this.status == 200) {
						document.getElementById("comparisonTable").innerHTML = this.responseText;
					}
				};

			// AJAX Call to Get Comparision Table

			xhttp.open("POST","GetComparisonTable.jsp?baselineTest="+baseTest+"&name="+currTest+"&prodType="+prodType,true);
			xhttp.send();
			}
	</script>
	<label class="text-danger">Product : </label>
					<select onchange="getCompTable('<%=baselineLoadTestNumber%>','<%=currLoadTestNumber%>',this.value)" id="productType" name="productType">
					   <option value="Overall" >Overall</option>
		<%
		        String[] tempTestNumList2;
				String tempTestNum2="";
				File[] listOfCurrentFoldersAggregate      = new File(currDir+"/"+currLoadTestNumber+"_"+currLoadTestDuration+"/AggregateReport").listFiles();
				Arrays.sort(listOfCurrentFoldersAggregate);
				File[] listOfBaselineFoldersAggregate      = new File(currDir+"/"+baselineLoadTestNumber+"_"+currLoadTestDuration+"/AggregateReport").listFiles();
				Arrays.sort(listOfBaselineFoldersAggregate);
				Set<File> hs1 = new TreeSet<>(Arrays.asList(listOfCurrentFoldersAggregate));
				Set<File> hs2 = new TreeSet<>(Arrays.asList(listOfBaselineFoldersAggregate));
				Set<String> allProductFile = new TreeSet<>();
				for(File temphs1: hs1)
					allProductFile.add(temphs1.getName().replace(".csv",""));
				for(File temphs2: hs2)
					allProductFile.add(temphs2.getName().replace(".csv",""));
				for(String tempFile : allProductFile)
						{	
							// If Both Tests Contains Same Product, then only Comparision Table is Displayed

							if(hs1.toString().contains(tempFile)&&hs2.toString().contains(tempFile))
							{
		%>
				    <option value="<%=tempFile%>"><%=tempFile%></option>
		<%			        }
						}
		%>
					</select>
					
</body>
</html>
