package sample;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;
import com.google.gson.*;

import org.json.*;
import sample.model.User;

public class ObjectBuilder implements Runnable {

    public void sendGetUsers() throws Exception {
        String s = "http://mocnodeserv.hopto.org:3000/users";
        URL url = new URL(s);
        Scanner scan = new Scanner(url.openStream());
        String res = new String();

        while (scan.hasNext())
            res += scan.nextLine();

        scan.close();
        JSONArray arr = new JSONArray(res);
        LinkedList<JSONObject> hs = new LinkedList<>();

        for (int i = 0; i < arr.length(); i++) {
            hs.add(arr.getJSONObject(i));
        }

        Iterator<JSONObject> it = hs.iterator();
        Gson gson = new GsonBuilder().create();
        while (it.hasNext()) {
            JSONObject job = it.next();
            Main.Users.put(job.getString("_id"),gson.fromJson(job.toString(), User.class));
        }

        System.out.println(Main.Users.toString());
    }

    @Override
    public void run() {
        try {
            this.sendGetUsers();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}