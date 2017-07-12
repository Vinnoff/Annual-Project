package sample.model;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.ObservableList;

/**
 * Created by MADMAX on 12/07/2017.
 */
public class Preferences {
    private StringProperty id;
    private ObservableList<ObjectProperty<Song>> songs;
    private ObservableList<ObjectProperty<Album>> albums;
    private ObservableList<ObjectProperty<Artist>> artists;
    private ObservableList<ObjectProperty<Genre>> genres;


}
