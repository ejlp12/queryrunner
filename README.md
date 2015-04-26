Simple web application tool for running a database query by specifiying a datasource JNDI name.
Query result is shown in a table and can be downloaded as CSV file.

Build the source using maven: "mvn clean install"
Deploy the  `queryrunner.war` in `target` directory into Java web/app server and access to http://hostname/queryrunner

`index2.jsp` is support for listing all available datasource JNDI name in WebLogic Application Server in dropdown list.
