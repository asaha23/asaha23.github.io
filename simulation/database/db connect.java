try {
	// TODO add your handling code here:
	Class.forName("org.sqlite.JDBC");
	Connection connection = DriverManager.getConnection("jdbc:sqlite:C:\\work\\database\\db\\chemdb");
	Statement statement = connection.createStatement();


	// Pull Data From Elements Table
	ResultSet resultSet = statement.executeQuery("SELECT name FROM chemdb_element");

	while (resultSet.next())
	{
		System.out.println("element name:" + resultSet.getString("name"));
	}




	ResultSet resultset = statement.executeQuery("SELECT name FROM chemdb_compound");

	while (resultSet.next())
	{
		System.out.println("compound name:" + resultSet.getString("name"));
	}
} catch (Exception ex) {
	Logger.getLogger(Rohan_projectView.class.getName()).log(Level.SEVERE, null, ex);
}