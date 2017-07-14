package sample.model;

import java.time.LocalDate;

/**
 * Created by MADMAX on 21/06/2017.
 */
public class Rewards {
    private String _id;
    private LocalDate created_at;
    private LocalDate updated_at;
    private String title;
    private String description;
    private String type;
    private int goldToAcces;

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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public int getGoldToAcces() {
        return goldToAcces;
    }

    public void setGoldToAcces(int goldToAcces) {
        this.goldToAcces = goldToAcces;
    }

    @Override
    public String toString() {
        return "Rewards{" +
                "_id='" + _id + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", type='" + type + '\'' +
                ", goldToAcces=" + goldToAcces +
                '}';
    }
}
