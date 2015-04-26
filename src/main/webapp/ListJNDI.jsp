<%@ page language="java" contentType="text/html;charset=UTF-8" errorPage="errorReportPage.jsp"%>
<%@ page import="javax.naming.Binding"%>
<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="javax.naming.NameClassPair"%>
<%@ page import="javax.naming.NamingEnumeration"%>
<%@ page import="javax.naming.NamingException, java.io.IOException"%>
<%!

/**
* Recursively exhaust the JNDI tree
*/
private static final void listContext(JspWriter out, Context ctx, String indent) throws NamingException, IOException  {
       NamingEnumeration list = ctx.listBindings("");
       while (list.hasMore()) {
           Binding item = (Binding) list.next();
           String className = item.getClassName();
           String name = item.getName();
           
           out.println(indent + className + " - " + name +  "<br/>");
           Object o = item.getObject();
           if (o instanceof javax.naming.Context) {
                listContext(out, (Context) o, indent + "&nbsp;&nbsp;");
           }
       }
}

private static final void listContext2(JspWriter out, Context ctx, String rootpath) throws NamingException, IOException  {
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
               out.println(jndiName + "<br/>");
           }
           path = rootpath;
       }
}

%>
<pre>
<%
String lookup = "java:comp/env";

if ( request.getParameter("lookup") != null && !"".equals(request.getParameter("lookup")) ) {
 lookup = request.getParameter("lookup"); 
} else {
    out.println("Please specify 'lookup' parameter<br/>");
}

 Context ctx = (Context)new InitialContext().lookup(lookup);
 listContext2(out, ctx, lookup);


%>
</pre>