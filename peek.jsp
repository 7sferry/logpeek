<%--
  ~ Copyright (c) 2018 by MR Ferry
  3.1 simplify some codes
 --%>

<%@ page import="java.io.*,java.util.*,java.lang.*" %>
<HTML>
<HEAD>
    <TITLE>Record's Spying v3.1 (c) MR F</TITLE>
</HEAD>

<BODY>
<%
	String link=request.getRequestURL().toString().split("\\?")[0];
	int limit=100;
	int halaman=request.getParameter("halaman")!=null?Integer.parseInt(request.getParameter("halaman")):1;
	int mulai=(halaman>1)?(halaman*limit)-limit:0;
	int akhir=halaman*limit;
	boolean isLog=request.getParameter("war")==null;
    String path = System.getProperty("catalina.base")+(isLog?"/logs/":"/webapps/");
	if(isLog){
		%><a href="?war">backup</a><br><%
	} else{
		%><a href=<%out.print(link);%>>logs</a><br><%
	}
    if(request.getParameter("file")==null){
        File folder = new File(path);
        File[] files = folder.listFiles();
        if(files!=null){
        	double total=files.length;
        	int pages=(int)Math.ceil(total/(double)limit);
			
            Arrays.sort(files,
				new Comparator<File>(){
					public int compare(File f1, File f2)
					{
						return Long.compare(f2.lastModified(),f1.lastModified());
					}
				});
            for(int a=mulai;a<(akhir>total?total:akhir);a++){
					if(files[a].isFile()){
						%><br> <a href="?file=<%out.println(files[a].getName()); if(!isLog){out.print("&war");}%>"><%out.println(files[a].getName());%></a><%
					}
			}
			if(pages!=1){
				%> <br><br> <%
				for (int i = 1; i <=pages; i++) {
					%><a <%if(halaman!=i){%>href="?halaman=<%out.println(i); if(!isLog){out.print("&war");}%>"<%}%>><%out.println(i);%></a><%
				}
			}
		}
	} else{
		%><a href="<%out.print(link);%>">up</a><pre><br><%
		path+=request.getParameter("file");
		if(path.toLowerCase().endsWith(".zip") || path.toLowerCase().endsWith(".war")){
			response.setContentType("APPLICATION/OCTET-STREAM");
			response.setHeader("Content-Disposition","attachment; filename=\""+request.getParameter("file")+"\"");
			FileInputStream stream = new FileInputStream(path);
			int i;
			while((i=stream.read())!=-1){
				out.write(i);
			}
			stream.close();
		} else{
			FileReader fileReader = new FileReader(path);
			BufferedReader reader = new BufferedReader(fileReader);
			String line;
			List<String> content=new ArrayList<String>();
			while ((line = reader.readLine()) != null) {
				content.add(line);
			}
			reader.close();
			fileReader.close();
			double total=content.size();
			int pages=(int)Math.ceil(total/(double)limit);
			
			for(int a=mulai;a<(akhir>total?total:akhir);a++){
				out.println(content.get(a));
			}
			%></pre><% out.println("memory used "+Runtime.getRuntime().totalMemory());
			if(pages!=1){
				%> <br><br> <%
				for (int i = 1; i <=pages; i++) {
					%><a <%if(halaman!=i){%>href="?file=<%out.print(request.getParameter("file"));%>&halaman=<%out.print(i);%>"<%}%>><%out.print(i);%></a> <%
				}
			}
		}
	}
%>
</BODY>
</HTML>