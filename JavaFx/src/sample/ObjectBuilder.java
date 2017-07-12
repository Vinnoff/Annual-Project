package sample;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Scanner;

import org.json.*;

public class ObjectBuilder {
    private final String USER_AGENT = "Mozilla/5.0";

    public void sendGetUsers() throws Exception {
        String s = "http://mocnodeserv.hopto.org:3000/users";

        URL url = new URL(s);
        Scanner scan = new Scanner(url.openStream());
        String res = new String();
        while (scan.hasNext())
            res += scan.nextLine();
        scan.close();

        JSONArray arr = new JSONArray(res);
        HashMap hs = new HashMap();
        for (int i = 0; i < arr.length(); i++) {
            JSONObject obj = arr.getJSONObject(i);
            System.out.println(obj);
            hs.put(obj.hashCode(), obj);
        }

        System.out.print(hs.toString());
    }
}