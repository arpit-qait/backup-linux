<html>
  <head>
    <title> GALE Reports </title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
  </head>

  <body>
    <%@ page import="java.util.*" %>
    <%@ page import="java.io.*" %>
    <%@ page import="java.util.regex.Matcher" %>
    <%@ page import="java.util.regex.Pattern" %>
      <div class="tab-pane active" id="AggregateReports">
<%
String currDir = "/home/qainfotech/apache-tomcat-8.5.23/webapps/ROOT/Reports";
String name = "2221";
File mainFolder = new File(currDir);
File[] mainFolders = mainFolder.listFiles();
String fileName="";
String testValue="";
String pattern = "";
for(int i=0; i<mainFolders.length;i++){
  fileName = mainFolders[i].getName().toString();
  if(fileName.startsWith(name.toString())){
    break;
}
}%>

<%
String fullStatFileLocation = "";
String statsDir = currDir+"/"+fileName+"/Stats";
mainFolder = new File(statsDir);
mainFolders = mainFolder.listFiles();
for(int i=0;i<mainFolders.length;i++){
  String stats_fileName = mainFolders[i].getName();
  String prodName = stats_fileName.replace("_Stats.csv", "");
  fullStatFileLocation = statsDir+"/"+stats_fileName;
  String lineOverall;
  String[] dataInLineOverall;
  FileReader fileReaderOverall = new FileReader(fullStatFileLocation);
  BufferedReader bufferedReaderOverall = new BufferedReader(fileReaderOverall);
  %>

  <div class="col-md-10 col-md-offset-2">
    <div class="text-center" style="background-color:#46C7C7;margin-bottom:10px;margin-top:25px;border-radius:10px;">
      <button type="button" class="btn btn-outline-info btn-xs" style="background-color: Transparent;border: none;outline:none;" >
          <h3 id="<%=prodName%>" style="color:white;" class="text-center" ><%=prodName%></h3>
      </button>
    </div>
  <table class="table table-bordered table-hover" style="font-size:14px;">
    <thead>
      <tr>
        <th>id</th>
        <th>type</th>
        <th>status</th>
        <th>doc count</th>
        <th>in queue time (ms)</th>
        <th>processing time (ms)</th>
        <th>total time (ms)</th>
        <th>worker</th>
      </tr>

    </thead>
    <tbody>
      <%
  while ((lineOverall = bufferedReaderOverall.readLine()) != null) {
    if(lineOverall.startsWith("id"))
      continue;

      %>
      <tr>
        <%
      dataInLineOverall = lineOverall.split(",");
      for(int j=0; j<dataInLineOverall.length;j++){
        %> <td> <%=dataInLineOverall[j]%></td>


      <%}%>
    </tr>
<%
}
bufferedReaderOverall.close();
fileReaderOverall.close();
    %>    </tbody>
    </table>
  </div>
    <%

}

%>
</div>

</body>
</html>
