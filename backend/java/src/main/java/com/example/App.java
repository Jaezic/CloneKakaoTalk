package com.example;

import java.io.IOException;
import java.net.DatagramSocket;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.json.JSONObject;

import java.sql.*; // sql 접속 라이브러리.

public class App {

    static Statement stmt;
    // private Connection conn; // 데이터베이스에 접근하게 해주는 객체.
    // private PreparedStatement pstmt;
    // private ResultSet rs; // 결과값을 담을 객체.

    // public App(){
    //     try{
    //         String dbURL = "jtbc:mysql://localhost:3306/networkDB"; //
    //         String dbID = "root";
    //         String dbPassword = "gachon";
    //         Class.forName("com.mysql.");

    //     }catch(Exception e){
    //         e.printStackTrace();
    //     }
    // }

    public static void main(String[] args) throws Exception {
        try {
            Class.forName("com.mysql.Jdbc.Driver"); 
            String jdbc_url = "jdbc:mysql://localhost:3306/networkDB";
            Connection con = DriverManager.getConnection(jdbc_url, "root", "gachon");
            stmt = con.createStatement(); 

            String sql = "select * from User";
            ResultSet result = stmt.executeQuery(sql);  
            System.out.println(result);
            
            DatagramSocket ds = new DatagramSocket(9999);
            ExecutorService pool = Executors.newFixedThreadPool(20);
            while (true) {
                System.out.println("Waiting for a packet reception..");
                UDPRequest request = UDP.receive(ds);
                pool.execute(new Thread(request, ds));
            }
        } catch (IOException e) {
        }
    }

    private static class Thread implements Runnable {
        private UDPRequest request;
        private DatagramSocket ds;

        Thread(UDPRequest request, DatagramSocket ds) {
            this.request = request;
            this.ds = ds;
        }

        @Override
        public void run() {
            try {
                if(request.method.equalsIgnoreCase("POST")){
                    if(request.route.equalsIgnoreCase("register")){
                        //System.out.println(request.data.get("name")); // 들어온 데이터 읽기
                        request.data.get("id");
                        JSONObject json = new JSONObject();
                        System.out.println("Connect");
                        json.put("value", "test");
                        

                        UDP.response(new UDPResponse(200, "OK", request.data), ds, request.ip, request.port); // 데이터 다시 보내기
                    }
                    else if(request.route.equalsIgnoreCase("login")){
                            //로그인 요청시 id,password insert
                           
                            JSONObject login_json = new JSONObject();
   
                            login_json.put("id", request.data.get("id")); // json file에서 load하여 login_json에 저장. 
                            login_json.put("password", request.data.get("password"));  // json file에서 load하여 login_json에 저장.             

                            //mysql load

                            //UDP.response(new UDPResponse(200, "OK", request.data), ds, request.ip, request.port); // 데이터 다시 보내기
                    }
                    else
                    UDP.response(new UDPResponse(0, "Invalid Route requested.", null), ds, request.ip, request.port);
                }
                else if(request.method.equalsIgnoreCase("GET")){

                }else
                UDP.response(new UDPResponse(0, "Invalid method requested.", null), ds, request.ip, request.port);
            } catch (IOException e) {
            }
        }
    }
}
