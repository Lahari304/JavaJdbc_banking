package com.banking;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Scanner;

public class BankServices {
	
	static Connection con = ConnectStatus.getConnected();
	static CallableStatement stat;

	static int createAccount(String name, int pin) throws SQLException{
		
			stat = con.prepareCall("{? = call CREATEACC(?,?)}");
			stat.registerOutParameter(1, Types.INTEGER);
			stat.setString(2, name);
			stat.setInt(3, pin);
			
			stat.execute();
			
			return stat.getInt(1);
	}
	
	static int checkBal(int accNo, int pin) throws SQLException {
		
		stat = con.prepareCall("{? = call CHECKBAL(?,?)}");
		stat.registerOutParameter(1, Types.INTEGER);
		stat.setInt(2, accNo);
		stat.setInt(3, pin);
		
		stat.execute();
		
		return stat.getInt(1);
	}
	
	static int withdrawal(int accNo, int pin, int amount) throws SQLException{
		
		stat = con.prepareCall("{?= call WITHDRAWAL(?,?,?)}");
		stat.registerOutParameter(1, Types.INTEGER);
		stat.setInt(2, accNo);
		stat.setInt(3, pin);
		stat.setInt(4, amount);
		
		stat.execute();
		
		return stat.getInt(1);
		
	}
	
	static int deposit(int accNo, int pin, int amount)throws SQLException {
		
		stat = con.prepareCall("{?= call DEPOSIT(?,?,?)}");
		stat.registerOutParameter(1, Types.INTEGER);
		stat.setInt(2,accNo);
		stat.setInt(3, pin);
		stat.setInt(4, amount);
		
		stat.execute();
		
		return stat.getInt(1);
	}
	
	public static void main(String[] args) throws Exception{
		
		Scanner sc = new Scanner(System.in);
		
		while(true) {
			System.out.println("\n\tWelcome User!\nPlease enter:\n"
				+ "A. To Create an account\n"
				+ "B. To Check balance of an existing account\n"
				+ "C. For Withdrawal\n"
				+ "D. To Deposit amount\n");
			char entry = sc.next().charAt(0);
			
			String name;
			int accNo, pin;
			
			System.out.println("Enter/Create and your 4-digit authentication pin:");
			pin = sc.nextInt();
			if(pin > 9999) {
				System.out.println("PIN cannot be more than 4 digits");
				entry = 'Z';
			}
			
			try {
			switch(entry) {
			
				case 'A':
					
					System.out.println("Please create your User Name:");
					name = sc.next();
					
					try{
						int ret_val = createAccount(name, pin);
						if(ret_val > 0)System.out.println("Account creation successful.\n"
								+ "Your Account Number is: "+ret_val);
					else System.out.println("Usename unavailable.");
					}
					catch(SQLException e) {
						System.out.println("Technical error. Try Again.");
						e.printStackTrace();
					}
					
					break;
				case 'B':
					
					System.out.println("Please enter your 6-digit Account Number:");
					accNo = sc.nextInt();
					
					int val = checkBal(accNo, pin);
					if(val == -1)System.out.println("Invalid details.. Retry.");
					else System.out.println("Your current Balance is: "+ val);
					break;
				
				case 'C':
					
					System.out.println("Please enter your 6-digit Account Number:");
					accNo = sc.nextInt();
					System.out.println("Enter the amount:");
					int amount = sc.nextInt();
					
					val = withdrawal(accNo, pin, amount);
					
					if(val==-1) System.out.println("Invalid credentials. Retry.");
					else if(val == -2) System.out.println("Insufficient funds.\n"
							+ "Your current balance is: "+val);
					else System.out.println("Withdrawal successful!"
							+ "Your current Balance is: "+ val);
					
					break;
					
				case 'D':
					
					System.out.println("Please enter your 6-digit Account Number:");
					accNo = sc.nextInt();
					System.out.println("Enter the amount:");
					amount = sc.nextInt();
					
					
					val = deposit(accNo, pin, amount);
					if(val == -1)System.out.println("Invalid details.. Retry.");
					else System.out.println("Deposit successful./n"
							+ "Your current Balance is: "+ val);
					
					break;
					
				default:
					System.out.println("Invalid entry. Please retry.\n");
			
			}}
			catch(SQLException e) {
				e.printStackTrace();
			}
			
			System.out.println("Exit services? Y or N :");
			entry = sc.next().charAt(0);
			
			if(entry == 'Y') break;
			else if(entry!='N') System.out.println("Invalid input. Restrating service..");
		}
		//end of while loop
		
		System.out.println("Thankyou for banking with us! Have a nice day.");
		try {sc.close();}
		catch(IllegalStateException e) {
			e.printStackTrace();
		}
		try{
			con.close();
			}catch(SQLException e) {
				e.printStackTrace();
		}
	}

}
