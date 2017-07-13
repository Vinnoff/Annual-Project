package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.BorderPane;
import javafx.stage.Stage;
import sample.model.User;

import java.io.IOException;
import java.util.HashMap;

public class Main extends Application {
    public Stage primaryStage;
    private BorderPane root;
    public Main mainApp;
    public static HashMap<String, User> Users;

    @Override
    public void start(Stage primaryStage) throws Exception{
        this.mainApp = this;
        this.primaryStage = primaryStage;
        this.primaryStage.setTitle("StatMaker");
        initRootLayout();
    }

    private void initRootLayout() {
        try {
            root = FXMLLoader.load(getClass().getResource("view/RootLayout.fxml"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        primaryStage.setScene(new Scene(root));
        primaryStage.show();

        showMainView();
    }

    public void showMainView() {
        try {
            // Load person overview.
            FXMLLoader loader = new FXMLLoader();
            loader.setLocation(Main.class.getResource("view/MainView.fxml"));
            AnchorPane personOverview = (AnchorPane) loader.load();

            // Set person overview into the center of root layout.
            root.setCenter(personOverview);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    public static void main(String[] args) {
        //launch(args);
        Users = new HashMap<>();
        ObjectBuilder ob = new ObjectBuilder();
        ob.run();
    }
}
