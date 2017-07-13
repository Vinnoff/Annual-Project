package sample.model;

import javafx.beans.property.LongProperty;
import javafx.beans.property.ObjectProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.ObservableList;

import java.io.File;
import java.time.LocalDate;
import java.util.HashMap;

/**
 * Created by MADMAX on 20/06/2017.
 */
public class User {
    private String id;
    private String userName;
    private String firstName;
    private String lastName;
    private String password;
    private String mail;
    private Rank rank;
    private Long globalScore;
    private Long gold;
    private HashMap<String,Game> games;
    private String location;
    private LocalDate birthDay;
    private LocalDate creation;
    private LocalDate modification;
    private Rewards rewards;
    private HashMap<String, User> friends;
    private HashMap<String, Playlist> playlist;
    private HashMap<String, Preferences> preferences;

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setMail(String mail) {
        this.mail = mail;
    }

    public void setGlobalScore(Long globalScore) {
        this.globalScore = globalScore;
    }

    public void setGold(Long gold) {
        this.gold = gold;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public void setBirthDay(LocalDate birthDay) {
        this.birthDay = birthDay;
    }

    public void setCreation(LocalDate creation) {
        this.creation = creation;
    }

    public void setModification(LocalDate modification) {
        this.modification = modification;
    }
}
