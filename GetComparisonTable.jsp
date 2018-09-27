<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<!-- Displays Comparision table For Two Products or Between Two Load Tests -->

<!-- Aggregating All files -->
<%
	String baselineLoadTestNumber = request.getParameter("baselineTest");
	if(!baselineLoadTestNumber.equals("noSelection"))
	{
	String currLoadTestNumber     = request.getParameter("name");
	String currLoadTestDuration   = (String)session.getAttribute("testValue");
	String currDir = (String)session.getAttribute("currDir");
	session.setAttribute("baseLoadTestNew", baselineLoadTestNumber);
	session.setAttribute("currLoadTestNew", currLoadTestNumber);
	
	String productType = request.getParameter("prodType");
	
	String desiredCurrentFolder = currLoadTestNumber+"_"+currLoadTestDuration;
	String desiredBaselineFolder = baselineLoadTestNumber+"_"+currLoadTestDuration;
	   
	File[] listOfCurrentFoldersAggregate      = new File(currDir+"/"+desiredCurrentFolder+"/AggregateReport").listFiles();
    Arrays.sort(listOfCurrentFoldersAggregate);
	File[] listOfBaselineFoldersAggregate      = new File(currDir+"/"+desiredBaselineFolder+"/AggregateReport").listFiles();
    Arrays.sort(listOfBaselineFoldersAggregate);
	
	Set<File> hs1 = new TreeSet<>(Arrays.asList(listOfCurrentFoldersAggregate));
	Set<File> hs2 = new TreeSet<>(Arrays.asList(listOfBaselineFoldersAggregate));
	
%> <!-- hs1 for Current Test, hs2 for Baseline Test --> <%

   if(productType.equals("Overall"))   
   {
	%> <!-- For Comparing Overall Details Of All Products --> <%

	Set<String> allProductFile = new TreeSet<>();
	for(File temphs1: hs1)
       allProductFile.add(temphs1.getName());
	for(File temphs2: hs2)
       allProductFile.add(temphs2.getName());
   File mainFolder                       = new File(currDir);
   File[] mainFolders                    = mainFolder.listFiles();
%>
<div class="text-center">
        <div class="col-sm-12">
			<table class="table table-bordered table-hover" style="font-size:14px;">
            <thead>   
			<!-- Table Header -->

                         <tr class="text-center text-primary">
                           <th>Products</th>
                           <th>Average Response Time (Seconds)</th>
                           <th>Samples</th>
						   <th>Error%</th>
                           <th>Average Response Time (Seconds)</th>
                           <th>Samples</th>
						   <th>Error%</th>
						   <th>Delta(Test <%=currLoadTestNumber%>-<%=baselineLoadTestNumber%>)</th>
                         </tr>
            </thead>
            <tbody>
			<%
						String prodCurrentNameWithExtension = "";String prodCurrentName = "";String pathProductCurrentAggregate = "";
						String prodBaselineNameWithExtension = "";String prodBaselineName = "";String pathProductBaselineAggregate = "";
                        String lineOverallBaseline="";String overallSampleBaseline="-";String overallResponseTimeBaseline="-";String overallErrorBaseline="-";
						String lineOverallCurrent="";String overallSampleCurrent="-";String overallResponseTimeCurrent="-";String overallErrorCurrent="-";
						String delta = "-";
						for(String tempFile : allProductFile)
						{ 
							prodBaselineNameWithExtension  = tempFile;
                            prodBaselineName               = prodBaselineNameWithExtension.replace(".csv","");
                            pathProductBaselineAggregate   = currDir+"/"+desiredBaselineFolder+"/AggregateReport/"+prodBaselineNameWithExtension;
                            pathProductCurrentAggregate    = currDir+"/"+desiredCurrentFolder+"/AggregateReport/"+prodBaselineNameWithExtension;
                            String[] dataInLineOverallBaseline;
                            String[] dataInLineOverallCurrent;
							
							if(hs2.toString().contains(tempFile)&&hs1.toString().contains(tempFile))

							{ %> <!-- If Both(Current And Baseline) Contains same Product --> <%

                                 FileReader fileReaderOverallBaseline         = new FileReader(pathProductBaselineAggregate);
                                 BufferedReader bufferedReaderOverallBaseline = new BufferedReader(fileReaderOverallBaseline);
                                 while((lineOverallBaseline = bufferedReaderOverallBaseline.readLine()) != null){
                                     if(lineOverallBaseline.startsWith("TOTAL"))
                                     {
                                            dataInLineOverallBaseline        = lineOverallBaseline.split(",");
                                            overallSampleBaseline            = dataInLineOverallBaseline[1];
                                            overallResponseTimeBaseline      = String.format("%.03f", Float.parseFloat(dataInLineOverallBaseline[2])/1000);
                                            overallErrorBaseline      = String.format("%.02f", Float.parseFloat(dataInLineOverallBaseline[7].replace("%",""))*100)+"%";
                                     }
                                     else
                                       continue;
						        }
								 
								 FileReader fileReaderOverallCurrent         = new FileReader(pathProductCurrentAggregate);
                                 BufferedReader bufferedReaderOverallCurrent = new BufferedReader(fileReaderOverallCurrent);
                                 while((lineOverallCurrent = bufferedReaderOverallCurrent.readLine()) != null){
                                     if(lineOverallCurrent.startsWith("TOTAL"))
                                     {
                                            dataInLineOverallCurrent        = lineOverallCurrent.split(",");
                                            overallSampleCurrent            = dataInLineOverallCurrent[1];
                                            overallResponseTimeCurrent      = String.format("%.03f", Float.parseFloat(dataInLineOverallCurrent[2])/1000);
                                            overallErrorCurrent      = String.format("%.02f", Float.parseFloat(dataInLineOverallCurrent[7].replace("%",""))*100)+"%";
                                     }
                                     else
                                       continue;
						        }
								bufferedReaderOverallCurrent.close();
								fileReaderOverallCurrent.close();
								bufferedReaderOverallBaseline.close();
								fileReaderOverallBaseline.close();
							if(!overallResponseTimeBaseline.equals("-")&&!overallResponseTimeCurrent.equals("-"))
								
							{   
								%> <!-- If Overall Response Time For Both Products Is Available --> <%

								delta = String.format("%.03f", Float.parseFloat(overallResponseTimeCurrent)-Float.parseFloat(overallResponseTimeBaseline));
								if(Float.parseFloat(delta)>0.5)
									delta = "<span style='color:red;font-weight:600;'>"+delta+"</span>";
							}
			%>
					<tr>
						<td><%=prodBaselineName%></td>
						<td class="text-center"><%=overallResponseTimeBaseline%></td>
						<td><%=String.format("%,d", Integer.parseInt(overallSampleBaseline))%></td>
						<td><%=overallErrorBaseline%></td>
						<td class="text-center"><%=overallResponseTimeCurrent%></td>
						<td><%=String.format("%,d", Integer.parseInt(overallSampleCurrent))%></td>
						<td><%=overallErrorCurrent%></td>
						<td><%=delta%></td>
					</tr>
			<%
						   }
						
						else if(!hs2.toString().contains(tempFile)&&hs1.toString().contains(tempFile))
						{  %> <!-- If Both(Current And Baseline) Not Contains same Product -->
							<!-- Only Current test contains the Product Details --> <%
								 overallResponseTimeBaseline=overallSampleBaseline=overallErrorBaseline="-";
							     FileReader fileReaderOverallCurrent         = new FileReader(pathProductCurrentAggregate);
                                 BufferedReader bufferedReaderOverallCurrent = new BufferedReader(fileReaderOverallCurrent);
                                 while((lineOverallCurrent = bufferedReaderOverallCurrent.readLine()) != null){
                                     if(lineOverallCurrent.startsWith("TOTAL"))
                                     {
                                            dataInLineOverallCurrent        = lineOverallCurrent.split(",");
                                            overallSampleCurrent            = dataInLineOverallCurrent[1];
                                            overallResponseTimeCurrent      = String.format("%.03f", Float.parseFloat(dataInLineOverallCurrent[2])/1000);
                                            overallErrorCurrent      = String.format("%.02f", Float.parseFloat(dataInLineOverallCurrent[7].replace("%",""))*100)+"%";
                                     }
                                     else
                                       continue;
						        }
								bufferedReaderOverallCurrent.close();
								fileReaderOverallCurrent.close();
								delta="-";
			%>
					<tr>
						<td><%=prodBaselineName%></td>
						<td class="text-center"><%=overallResponseTimeBaseline%></td>
						<td><%=overallSampleBaseline%></td>
						<td><%=overallErrorBaseline%></td>
						<td class="text-center"><%=overallResponseTimeCurrent%></td>
						<td><%=String.format("%,d", Integer.parseInt(overallSampleCurrent))%></td>
						<td><%=overallErrorCurrent%></td>
						<td><%=delta%></td>
					</tr>
			<%
						}
						
						else if(hs2.toString().contains(tempFile)&&!hs1.toString().contains(tempFile))
						{   %> <!-- If Both(Current And Baseline) Not Contains same Product --> 
							<!-- Only Baseline Test contains the Product Details --> <%
								 overallResponseTimeCurrent=overallSampleCurrent=overallErrorCurrent="-";
                                 FileReader fileReaderOverallBaseline         = new FileReader(pathProductBaselineAggregate);
                                 BufferedReader bufferedReaderOverallBaseline = new BufferedReader(fileReaderOverallBaseline);
                                 while((lineOverallBaseline = bufferedReaderOverallBaseline.readLine()) != null){
                                     if(lineOverallBaseline.startsWith("TOTAL"))
                                     {
                                            dataInLineOverallBaseline        = lineOverallBaseline.split(",");
                                            overallSampleBaseline            = dataInLineOverallBaseline[1];
                                            overallResponseTimeBaseline      = String.format("%.03f", Float.parseFloat(dataInLineOverallBaseline[2])/1000);
                                            overallErrorBaseline      = String.format("%.02f", Float.parseFloat(dataInLineOverallBaseline[7].replace("%",""))*100)+"%";
                                     }
                                     else
                                       continue;
						        }
								bufferedReaderOverallBaseline.close();
								fileReaderOverallBaseline.close();
								delta="-";
						
			%>
					<tr>
						<td><%=prodBaselineName%></td>
						<td class="text-center"><%=overallResponseTimeBaseline%></td>
						<td><%=String.format("%,d", Integer.parseInt(overallSampleBaseline))%></td>
						<td><%=overallErrorBaseline%></td>
						<td class="text-center"><%=overallResponseTimeCurrent%></td>
						<td><%=overallSampleCurrent%></td>
						<td><%=overallErrorCurrent%></td>
						<td><%=delta%></td>
					</tr>
			<%
						}
					 }
			%>
			</tbody>
		</div>		 
</div>
 <%		}
 else{
%> <!-- For Selected Product -->
	
	 
	 <div class="text-center">
        <div class="col-sm-12">
			<table class="table table-bordered table-hover" style="font-size:14px;">
            <thead>
                         <tr class="text-center text-primary">
                           <th>Label</th>
                           <th>Average Response Time (Seconds)</th>
                           <th>Samples</th>
						   <th>Error%</th>
                           <th>Average Response Time (Seconds)</th>
                           <th>Samples</th>
						   <th>Error%</th>
						   <th>Delta(Test <%=currLoadTestNumber%>-<%=baselineLoadTestNumber%>)</th>
                         </tr>
            </thead>
            <tbody>
	 <!-- Aggregating All request Details -->
	 <%
			FileReader fileReaderOverallBaseline         = new FileReader(currDir+"/"+desiredBaselineFolder+"/AggregateReport/"+productType+".csv");
            BufferedReader bufferedReaderOverallBaseline = new BufferedReader(fileReaderOverallBaseline);
			FileReader fileReaderOverallCurrent         = new FileReader(currDir+"/"+desiredCurrentFolder+"/AggregateReport/"+productType+".csv");
            BufferedReader bufferedReaderOverallCurrent  = new BufferedReader(fileReaderOverallCurrent);
			Set<String> allTransactionName = new TreeSet<>();
			HashMap<String,String> baseTransactionName = new HashMap<String,String>();
			HashMap<String,String> currTransactionName = new HashMap<String,String>();
			String[] dataInLine;String label;String resTime;String sample;String err;
			String lineOverallBaseline="";String lineOverallCurrent="";
            while((lineOverallBaseline = bufferedReaderOverallBaseline.readLine()) != null){
                if(!lineOverallBaseline.startsWith("TOTAL")&&!lineOverallBaseline.startsWith("sampler_label"))
                {
					dataInLine       = lineOverallBaseline.split(",");
                    label            = dataInLine[0];
                    resTime            = String.format("%.03f", Float.parseFloat(dataInLine[2])/1000);
                    sample            = dataInLine[1];
                    err            = String.format("%.02f", Float.parseFloat(dataInLine[7].replace("%",""))*100)+"%";
					baseTransactionName.put(label,sample+"*"+resTime+"*"+err);
					allTransactionName.add(label);
				}
			}

            while((lineOverallCurrent = bufferedReaderOverallCurrent.readLine()) != null){
                if(!lineOverallCurrent.startsWith("TOTAL")&&!lineOverallCurrent.startsWith("sampler_label"))
                {
					dataInLine        = lineOverallCurrent.split(",");
                    label            = dataInLine[0];
                    resTime            = String.format("%.03f", Float.parseFloat(dataInLine[2])/1000);
                    sample            = dataInLine[1];
                    err            = String.format("%.02f", Float.parseFloat(dataInLine[7].replace("%",""))*100)+"%";
					currTransactionName.put(label,sample+"*"+resTime+"*"+err);
					allTransactionName.add(label);
				}
			}

			bufferedReaderOverallBaseline.close();
			fileReaderOverallBaseline.close();
			bufferedReaderOverallCurrent.close();
			fileReaderOverallCurrent.close();
			String overallSampleBaseline="-";String overallResponseTimeBaseline="-";String overallErrorBaseline="-";
			String overallSampleCurrent="-";String overallResponseTimeCurrent="-";String overallErrorCurrent="-";
			
			for(String tempFile : allTransactionName)
			{      %> <!-- Similar Cases As in OverAll Product Section --> <%
				String responseTimeBaseline="-";String sampleBaseline="-";String errorBaseline="-";
				String responseTimeCurrent="-";String sampleCurrent="-";String errorCurrent="-";
				String deltaResponse="-";String[] currTransactionDataArray;String[] baseTransactionDataArray;
				if(baseTransactionName.keySet().toString().contains(tempFile)&&currTransactionName.keySet().toString().contains(tempFile))
				{
					String currTransactionData = currTransactionName.get(tempFile);
					String baseTransactionData = baseTransactionName.get(tempFile);
					currTransactionDataArray = currTransactionData.split("\\*");
					baseTransactionDataArray = baseTransactionData.split("\\*");
					responseTimeBaseline = baseTransactionDataArray[1];
					sampleBaseline = baseTransactionDataArray[0];
					errorBaseline = baseTransactionDataArray[2];
					responseTimeCurrent = currTransactionDataArray[1];
					sampleCurrent = currTransactionDataArray[0];
					errorCurrent = currTransactionDataArray[2];
					if(!responseTimeBaseline.equals("-")&&!responseTimeCurrent.equals("-"))
							{
								deltaResponse = String.format("%.03f", Float.parseFloat(responseTimeCurrent)-Float.parseFloat(responseTimeBaseline));
								if(Float.parseFloat(deltaResponse)>0.5)
									deltaResponse = "<span style='color:red;font-weight:600;'>"+deltaResponse+"</span>";
							}
					%>
					<tr>
						<td class="text-left"><%=tempFile%></td>
						<td class="text-center"><%=responseTimeBaseline%></td>
						<td><%=String.format("%,d", Integer.parseInt(sampleBaseline))%></td>
						<td><%=errorBaseline%></td>
						<td class="text-center"><%=responseTimeCurrent%></td>
						<td><%=String.format("%,d", Integer.parseInt(sampleCurrent))%></td>
						<td><%=errorCurrent%></td>
						<td><%=deltaResponse%></td>
					</tr>
			       <%
				}
				if(baseTransactionName.keySet().toString().contains(tempFile)&&!currTransactionName.keySet().toString().contains(tempFile))
				{
					String baseTransactionData = baseTransactionName.get(tempFile);
					baseTransactionDataArray = baseTransactionData.split("\\*");
					responseTimeBaseline = baseTransactionDataArray[1];
					sampleBaseline = baseTransactionDataArray[0];
					errorBaseline = baseTransactionDataArray[2];
					responseTimeCurrent = "-";
					sampleCurrent = "-";
					errorCurrent = "-";
					if(!responseTimeBaseline.equals("-")&&!responseTimeCurrent.equals("-"))
							{
								deltaResponse = String.format("%.03f", Float.parseFloat(responseTimeCurrent)-Float.parseFloat(responseTimeBaseline));
								if(Float.parseFloat(deltaResponse)>0.5)
									deltaResponse = "<span style='color:red;font-weight:600;'>"+deltaResponse+"</span>";
							}
					%>
					<tr>
						<td class="text-left"><%=tempFile%></td>
						<td class="text-center"><%=responseTimeBaseline%></td>
						<td><%=String.format("%,d", Integer.parseInt(sampleBaseline))%></td>
						<td><%=errorBaseline%></td>
						<td class="text-center"><%=responseTimeCurrent%></td>
						<td><%=sampleCurrent%></td>
						<td><%=errorCurrent%></td>
						<td><%=deltaResponse%></td>
					</tr>
			       <%
				}
				if(!baseTransactionName.keySet().toString().contains(tempFile)&&currTransactionName.keySet().toString().contains(tempFile))
				{
					String currTransactionData = currTransactionName.get(tempFile);
					currTransactionDataArray = currTransactionData.split("\\*");
					responseTimeBaseline = "-";
					sampleBaseline = "-";
					errorBaseline = "-";
					responseTimeCurrent = currTransactionDataArray[1];
					sampleCurrent = currTransactionDataArray[0];
					errorCurrent = currTransactionDataArray[2];
					deltaResponse="-";
					%>
					<tr>
						<td class="text-left"><%=tempFile%></td>
						<td class="text-center"><%=responseTimeBaseline%></td>
						<td><%=sampleBaseline%></td>
						<td><%=errorBaseline%></td>
						<td class="text-center"><%=responseTimeCurrent%></td>
						<td><%=String.format("%,d", Integer.parseInt(sampleCurrent))%></td>
						<td><%=errorCurrent%></td>
						<td><%=deltaResponse%></td>
					</tr>
			       <%
				}
			}
			%>
			</tbody>
			</table>
		</div>
	</div>
			<%
    }
}
 %>
