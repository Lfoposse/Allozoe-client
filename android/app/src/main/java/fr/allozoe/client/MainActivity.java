package fr.allozoe.client;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.app.FlutterFragmentActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

@SuppressWarnings("unchecked")
public class MainActivity extends FlutterFragmentActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}
