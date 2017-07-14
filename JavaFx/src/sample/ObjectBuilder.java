package sample;

import java.net.URL;
import java.util.*;
import com.google.gson.*;

import org.json.*;
import sample.model.User;

public class ObjectBuilder implements Runnable {
    private static final String BASEURL = "http://mocnodeserv.hopto.org:3000/";
    private Scanner scan;
    private String res;

    public void sendGetUsers() throws Exception {
        this.scan = new Scanner(new URL(BASEURL +"users").openStream());
        build(Main.Users);
    }

    public void sendGetSongs() throws Exception {
        this.scan = new Scanner(new URL(BASEURL +"song").openStream());
        build(Main.Songs);
    }

    public void sendGetPlaylists() throws Exception {
        this.scan = new Scanner(new URL(BASEURL +"playlist").openStream());
        build(Main.Playlists);
    }

    public void sendGetGames() throws Exception {
        this.scan = new Scanner(new URL(BASEURL +"game").openStream());
        build(Main.Games);
    }

    public void sendGetRank() throws Exception {
        this.scan = new Scanner(new URL(BASEURL +"rank").openStream());
        build(Main.Games);
    }

    public void build(Object mainHm) {
        this.res = new String();

        while (this.scan.hasNext())
            this.res += scan.nextLine();

        scan.close();
        JSONArray arr = new JSONArray(res);
        LinkedList<JSONObject> hs = new LinkedList<>();

        for (int i = 0; i < arr.length(); i++)
            hs.add(arr.getJSONObject(i));

        Iterator<JSONObject> it = hs.iterator();
        Gson gson = new GsonBuilder().create();

        while (it.hasNext()) {
            JSONObject job = it.next();
            ((HashMap)mainHm).put(job.getString("_id"),gson.fromJson(job.toString(), User.class));
        }
    }

    @Override
    public void run() {
        try {
            this.sendGetUsers();
            this.sendGetGames();
            this.sendGetPlaylists();
            this.sendGetRank();
            this.sendGetSongs();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}