package com.incconutwo.savememory;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

public class LaunchActivity extends Activity {
    private static final String PKG = "com.samsung.android.app.memory";
    private static final String CLS = "com.samsung.android.app.memory.feature.capture.ScreenCaptureViewerActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        try {
            Intent i = new Intent(Intent.ACTION_MAIN);
            i.setComponent(new ComponentName(PKG, CLS));
            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(i);
        } catch (Exception e) {
            Toast.makeText(this, "Couldn't open Samsung Memory: " + e.getMessage(), Toast.LENGTH_LONG).show();
        }
        finish();
    }
}
