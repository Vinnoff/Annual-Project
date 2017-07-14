package sample.model;

import java.time.LocalDate;

/**
 * Created by MADMAX on 14/07/2017.
 */
public class Score {
    private String _id;
    private LocalDate created_at;
    private LocalDate updated_at;
    private int scoreInGame;
    private int isFinished;
    private User user;
    private Game game;

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

    public int getScoreInGame() {
        return scoreInGame;
    }

    public void setScoreInGame(int scoreInGame) {
        this.scoreInGame = scoreInGame;
    }

    public int getIsFinished() {
        return isFinished;
    }

    public void setIsFinished(int isFinished) {
        this.isFinished = isFinished;
    }

    @Override
    public String toString() {
        return "Score{" +
                "_id='" + _id + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", scoreInGame=" + scoreInGame +
                ", isFinished=" + isFinished +
                ", user=" + user +
                ", game=" + game +
                '}';
    }
}
