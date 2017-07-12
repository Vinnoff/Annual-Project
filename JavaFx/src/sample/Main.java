package sample;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.scene.layout.AnchorPane;
import javafx.stage.Stage;

import java.io.IOException;

public class Main extends Application {
    Stage primaryStage;

    @Override
    public void start(Stage primaryStage) throws Exception{
        this.primaryStage = primaryStage;
        initRootLayout();
    }

    private void initRootLayout() {
        AnchorPane root = null;
        ObjectBuilder objb = new ObjectBuilder();
        try {
            objb.sendGetUsers();
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            root = FXMLLoader.load(getClass().getResource("view/sample.fxml"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        primaryStage.setTitle("StatMaker");
        primaryStage.setScene(new Scene(root));
        primaryStage.show();
    }


    public static void main(String[] args) {
        launch(args);
    }
}
