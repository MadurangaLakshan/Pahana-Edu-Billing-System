package com.pahana.util;

import java.sql.Connection;


public class DBConnectionFactory {
	
	 public static Connection getConnection() {
	        return DBConnection.getInstance().getConnection();
	    }

}
