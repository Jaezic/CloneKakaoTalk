package com.example;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

public class CONNECT {
    static void userConnect(Network socket, Request request) throws JSONException, Exception {
        if (App.connected_sockets.containsKey(request.data.get("userID"))) {
            App.connected_sockets.get(request.data.get("userID")).close();
        }
        App.connected_sockets.put(request.data.get("userID").toString(), socket);
        System.out.println(App.connected_sockets);
        App.pool.execute(new ManagementTCPSocket(request.data.get("userID").toString()));
        socket.response(new Response(200, "OK", null), request.ip,
                request.port);
    }

    private static class ManagementTCPSocket implements Runnable {
        String userID;

        public ManagementTCPSocket(String userID) {
            this.userID = userID;
        }

        @Override
        public void run() {
            try {
                while (true) {
                    Thread.sleep(3000);
                    Network value = App.connected_sockets.get(userID);
                    BufferedReader in = new BufferedReader(new InputStreamReader(value.tcpSocket.getInputStream()));
                    int inputMessage = in.read();
                    System.out.println(userID + "'s Socket is disconnected");
                    if (inputMessage == -1) {
                        value.tcpSocket.close();
                        App.connected_sockets.remove(userID);
                        CONNECT.broadcastFetchFriend("null");
                        break;
                    }
                }
            } catch (Exception e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    static void broadcastFetchFriend(String requestUserID) throws IOException, Exception {
        int count = 0;
        if (!requestUserID.equals("null"))
            while (true) {
                Thread.sleep(1000);
                if (App.connected_sockets.containsKey(requestUserID))
                    break;
                else {
                    count++;
                }
                if (count == 10) {
                    System.out.println("Error : Broadcast Not Found RequestUserID in TCP Sockets");
                    return;
                }
            }
        for (String key : App.connected_sockets.keySet()) {
            Network value = App.connected_sockets.get(key);
            if (!key.equals(requestUserID)) {
                value.response(new Response(200, "updateFriend", null), value.tcpSocket.getInetAddress(),
                        value.tcpSocket.getPort());
            }
        }
    }

    static void broadcastReceivePostChat(String requestUserID, List<String> targetUserID)
            throws IOException, Exception {
        for (String key : App.connected_sockets.keySet()) {
            Network value = App.connected_sockets.get(key);
            if (!key.equals(requestUserID) && targetUserID.contains(key)) {
                value.response(new Response(200, "receivePostChat", null), value.tcpSocket.getInetAddress(),
                        value.tcpSocket.getPort());
            }
        }
    }
}
