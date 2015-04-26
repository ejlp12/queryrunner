<%@ page 
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1" 
import="java.sql.*,
        javax.naming.InitialContext,
        javax.naming.NamingException,
        javax.sql.DataSource,
        java.io.IOException,
        javax.servlet.jsp.*" 
errorPage="errorReportPage.jsp"		
%>
<%@ page import="javax.naming.Binding"%>
<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.NamingEnumeration"%><%! InitialContext context = null;
    DataSource cachedDataSource = null;
	Connection conn = null;
	Statement stmn = null; 
	ResultSet rs = null;
	boolean resultToFile = false;
	String JNDI_NAME = "";
    
    

private static final void listContext2(JspWriter out, Context ctx, String rootpath) throws NamingException, java.io.IOException  {
       NamingEnumeration list = ctx.listBindings("");
       while (list.hasMore()) {
           Binding item = (Binding) list.next();
           String className = item.getClassName();
           String name = item.getName();
           String path = "";
           boolean hasChild = false;
           if (rootpath.endsWith("/")) {
                path = rootpath.substring(0, path.length()-1);
           } 
           path = rootpath + "/" + name;
           
           
           Object o = item.getObject();
           if (o instanceof javax.naming.Context) {
                hasChild = true;
                listContext2(out, (Context) o, path);
           }
           
           if ( !hasChild ) {
               String jndiName = path.replace('/','.');
               if ( jndiName.startsWith(".") ) {
                    jndiName = jndiName.substring(1, path.length());
               }
               out.println("<option value=\"" + jndiName + "\">" + jndiName + "</option>");
           }                      
           
           path = rootpath;
       }
}

   
%><%

// Check whether result to CSV file or not
resultToFile = ( request.getParameter("file") != null && !"".equals(request.getParameter("file")) );

if ( !resultToFile ) { %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Query runner</title>
</head>

<body>
<p>
<form action="index.jsp" method="POST">	
    DataSource name: <select name="datasource">
    <%
 String lookup = "java:jboss";
 Context ctx = (Context)new InitialContext().lookup(lookup);
 listContext2(out, ctx, lookup);   
    %></select><br/>
	Query: <textarea cols="100" rows="10"  name="query"></textarea>
	<br/>
	<input type="checkbox" name="file" value="true"/>Download result as CSV file
	<br/>
	<br/>
	<INPUT type="submit"/>
</form>
<p><% } %><%
if ( request.getParameter("datasource") != null && !"".equals(request.getParameter("datasource")) &&
     request.getParameter("query") != null && !"".equals(request.getParameter("query")) ) {

    context = new InitialContext();
    JNDI_NAME = request.getParameter("datasource");
    cachedDataSource = (DataSource) context.lookup(JNDI_NAME);	
    
	try {
	
		conn = cachedDataSource.getConnection();
		stmn = conn.createStatement();
		stmn.execute( (String)request.getParameter("query") );
		rs = stmn.getResultSet();		

		if (rs != null) {
			if ( resultToFile ) {
			    response.setContentType("text/csv");
			    response.addHeader("Content-Disposition", "attachment;filename=\"result.csv\"");
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();
				for(int col = 1; col <= columnCount; col++) {
					out.print(rsmd.getColumnLabel(col));
					if ( col != columnCount ) out.print(",");
				}
				out.println();				
				
				while (rs.next()) {
			        for(int col = 1; col <= columnCount; col++) {
			          	out.print(rs.getString(col));
			          	if ( col != columnCount ) out.print(",");
			        } 
			        out.println();
				}			    			
			} else 	{	
				ResultSetMetaData rsmd = rs.getMetaData();
				int columnCount = rsmd.getColumnCount();

				out.println("Execute query successfull. Query is: <br><pre>" + request.getParameter("query") + "</pre>");
				out.println("<table border='1' cellpading='0' cellspacing='0'><tr>");
				for(int col = 1; col <= columnCount; col++) {
					out.println("<td nowrap><font face='Arial' size='2'><b>" + rsmd.getColumnLabel(col) + "</b> (" + rsmd.getColumnTypeName(col)+") </font></td>");
				}
				out.println("</tr>\n<tr>");				
				
				while (rs.next()) {
			        for(int col = 1; col <= columnCount; col++) {
			          	out.println("<td><font face='Arial' size='2'>" + rs.getString(col) + "</font></td>");
			        } 
			        out.println("</tr>");
				}
				out.println("</table>");
			}
		}
	} catch (Exception e) {
		out.println("Error occured: " + e.getMessage() + "<br>");
	} finally {
        if (rs != null) 
            try { rs.close(); } catch (Exception e) {};
        if (stmn != null) 
            try { stmn.close(); } catch (Exception e) {};
        if (conn != null)
            try { conn.close(); } catch (Exception e) {};
	}	
}
%>
<% if ( !resultToFile ) { %>
</p>
</body>
</html>
<% } %>
