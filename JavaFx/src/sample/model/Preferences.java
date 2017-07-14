package sample.model;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.ObservableList;

import java.time.LocalDate;

/**
 * Created by MADMAX on 12/07/2017.
 */
public class Preferences {
    private StringProperty _id;
    private LocalDate created_at;
    private LocalDate updated_at;
    private ObservableList<ObjectProperty<Song>> songs;
    private ObservableList<ObjectProperty<Album>> albums;
    private ObservableList<ObjectProperty<Artist>> artists;
    private ObservableList<ObjectProperty<Genre>> genres;

    public String get_id() {
        return _id.get();
    }

    public StringProperty _idProperty() {
        return _id;
    }

    public void set_id(String _id) {
        this._id.set(_id);
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

    @Override
    public String toString() {
        return "Preferences{" +
                "_id=" + _id +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                '}';
    }
}
