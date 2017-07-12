package sample.model;

import javafx.beans.property.LongProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.ObservableList;

import java.io.File;
import java.time.LocalDate;

/**
 * Created by MADMAX on 20/06/2017.
 */
public class User {
    private StringProperty id;
    private StringProperty userName;
    private StringProperty firstName;
    private StringProperty lastName;
    private StringProperty password;
    private StringProperty mail;
    private ObjectProperty<Rank> rank;
    private LongProperty globalScore;
    private LongProperty gold;
    private ObservableList<ObjectProperty<Game>> games;
    //private ObjectProperty<File> avatar;
    private StringProperty location;
    private ObjectProperty<LocalDate> birthDay;
    private ObservableList<ObjectProperty<Rewards>> rewards;
    private ObservableList<ObjectProperty<User>> friends;
    private ObservableList<ObjectProperty<Playlist>> playlist;
    private ObservableList<ObjectProperty<Preferences>> preferences;

    public User(StringProperty id, StringProperty userName, StringProperty firstName, StringProperty lastName,
                StringProperty password, StringProperty mail, ObjectProperty<Rank> rank, LongProperty globalScore,
                LongProperty gold, StringProperty location, ObjectProperty<LocalDate> birthDay) {
        this.id = id;
        this.userName = userName;
        this.firstName = firstName;
        this.lastName = lastName;
        this.password = password;
        this.mail = mail;
        this.rank = rank;
        this.globalScore = globalScore;
        this.gold = gold;
        this.location = location;
        this.birthDay = birthDay;
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
