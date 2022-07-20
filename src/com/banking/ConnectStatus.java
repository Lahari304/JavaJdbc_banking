package com.banking;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectStatus{
	
	static Connection con;
	
	public static Connection getConnected() {
	
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
		
			String url = "jdbc:oracle:thin:@localhost:1521:orcl";
			String uname = "scott";
			String password = "tiger";
		
			con = DriverManager.getConnection(url, uname, password);
			
			if(con != null) {
				System.out.println("Connected successfully...\n");
			}
			else {
				System.out.println("Can't connect at this point..");
			}
		
		}catch(ClassNotFoundException e) {
			e.printStackTrace();
		}catch(SQLException e) {
			e.printStackTrace();
		}
	
		return con;
	}
}
