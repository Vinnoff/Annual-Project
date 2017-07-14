package sample.model;

import java.time.LocalDate;
import java.util.HashMap;

/**
 * Created by MADMAX on 21/06/2017.
 */
public class Game {
    private String _id;
    private LocalDate created_at;
    private LocalDate updated_at;
    private int difficulty;
    private boolean isMultiplayer;
    private boolean isPublic;
    private boolean isFinished;
    private HashMap<String, Song> songs;
    private HashMap<String, Score> scores;

    public String get_id() {
        return _id;
    }

    public void set_id(String _id) {
        this._id = _id;
    }

    public LocalDate getCreated_at() {
        return created_at;
    }

    public void setCreated_at(LocalDate created_at) {
        this.created_at = created_at;
    }

    public LocalDate getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(LocalDate updated_at) {
        this.updated_at = updated_at;
    }

    public int getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(int difficulty) {
        this.difficulty = difficulty;
    }

    public boolean isMultiplayer() {
        return isMultiplayer;
    }

    public void setMultiplayer(boolean multiplayer) {
        isMultiplayer = multiplayer;
    }

    public boolean isPublic() {
        return isPublic;
    }

    public void setPublic(boolean aPublic) {
        isPublic = aPublic;
    }

    public boolean isFinished() {
        return isFinished;
    }

    public void setFinished(boolean finished) {
        isFinished = finished;
    }

    @Override
    public String toString() {
        return "Game{" +
                "_id='" + _id + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", difficulty=" + difficulty +
                ", isMultiplayer=" + isMultiplayer +
                ", isPublic=" + isPublic +
                ", isFinished=" + isFinished +
                ", songs=" + songs +
                ", scores=" + scores +
                '}';
    }
}
