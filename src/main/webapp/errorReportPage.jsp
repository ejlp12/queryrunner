<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="true"
import="java.io.*"
%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<TITLE>Error</TITLE>
<LINK rel="stylesheet" href="<%=request.getContextPath()%>/theme/style.css" type="text/css">
<script language="javascript">
	function toggle() {
		if (document.all.detailErr.style.display == "none") {
			document.all.detailErr.style.display="";
		} else {
			document.all.detailErr.style.display="none";
		}
	}
</script>
</HEAD>

<BODY>
<DIV style="OVERFLOW: auto; WIDTH: 100%; HEIGHT: 100%">
<table border="0" cellpadding="5" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%" id="AutoNumber1">
  <tr>
    <td width="100%" style="padding:5; border:1px dotted #CC0000; background-color: #FFCCCC; font-family:Tahoma; font-size:11px; color:#CC0000">
    	Error Occured: <%= exception.getMessage() %>
    	<br>
    	<hr>
		<IMG border="0" src="<%=request.getContextPath()%>/images/down.gif" width="16" height="16" onClick="toggle()" style="cursor:hand">
    	
    	<table border="0" width="100%" id="detailErr" style="display:none">
    	 	<tr>
    	 		<td>
    	 		<code>
    	 		<pre style="font-family:Tahoma; font-size:11px; color:#CC0000">
    	 		<% 
    	 		StringWriter sw = new StringWriter();
    	 		PrintWriter pw = new PrintWriter(sw);
    	 		exception.printStackTrace(pw);
				out.println(sw);
    	 		%>
    	 		</pre>
    	 		</code>
    	 		</td>
    	 	</tr>
    	</table>

    </td>
  </tr>
</table>
</DIV>
</BODY>
</HTML>
