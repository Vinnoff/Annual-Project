package sample.model;

import java.time.LocalDate;
import java.util.HashMap;

/**
 * Created by MADMAX on 20/06/2017.
 */
public class User {


    private String _id;
    private LocalDate created_at;
    private LocalDate updated_at;
    private String userName;
    private String firstName;
    private String lastName;
    private boolean isAdmin;
    private String mail;
    private Rank rank;
    private Long globalScore;
    private Long gold;
    private HashMap<String,Game> games;
    private String location;
    private LocalDate birthDay;
    private Rewards rewards;
    private HashMap<String, User> friends;
    private HashMap<String, Playlist> playlist;
    private HashMap<String, Preferences> preferences;

    public void set_id(String _id) {
        this._id = _id;
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

    public void setCreated_at(LocalDate created_at) {
        this.created_at = created_at;
    }

    public void setUpdated_at(LocalDate updated_at) {
        this.updated_at = updated_at;
    }

    public String get_id() {
        return _id;
    }

    public String getUserName() {
        return userName;
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public String getMail() {
        return mail;
    }

    public Rank getRank() {
        return rank;
    }

    public void setRank(Rank rank) {
        this.rank = rank;
    }

    public Long getGlobalScore() {
        return globalScore;
    }

    public Long getGold() {
        return gold;
    }

    public String getLocation() {
        return location;
    }

    public LocalDate getBirthDay() {
        return birthDay;
    }

    public LocalDate getCreated_at() {
        return created_at;
    }

    public LocalDate getUpdated_at() {
        return updated_at;
    }

    public Rewards getRewards() {
        return rewards;
    }

    public void setRewards(Rewards rewards) {
        this.rewards = rewards;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin(boolean admin) {
        isAdmin = admin;
    }

    @Override
    public String toString() {
        return "User{" +
                "_id='" + _id + '\'' +
                ", created_at=" + created_at +
                ", updated_at=" + updated_at +
                ", userName='" + userName + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", isAdmin=" + isAdmin +
                ", mail='" + mail + '\'' +
                ", rank=" + rank +
                ", globalScore=" + globalScore +
                ", gold=" + gold +
                ", games=" + games +
                ", location='" + location + '\'' +
                ", birthDay=" + birthDay +
                ", rewards=" + rewards +
                ", friends=" + friends +
                ", playlist=" + playlist +
                ", preferences=" + preferences +
                '}';
    }
}
