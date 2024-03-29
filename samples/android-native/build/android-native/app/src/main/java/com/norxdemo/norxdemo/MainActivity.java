package com.norxdemo.norxdemo;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.util.Log;

import org.orx.lib.OrxNativeActivity; // base class so that native methods signature match package+method

/**
 * Copied from MainActivity.java in Orx (/demo/android-native/)
 */
public class MainActivity extends OrxNativeActivity {

    private Handler mHandler = new Handler();
    private View mDecorView;

    //static {
    //    System.loadLibrary("c++_shared");
    //}

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mDecorView = getWindow().getDecorView();
        mDecorView.setOnSystemUiVisibilityChangeListener(visibility -> {
            if ((visibility & View.SYSTEM_UI_FLAG_FULLSCREEN) == 0) {
                setImmersiveMode();
            }
        });

        Log.i("MainActivity", "NorxDemo MainActivity created");
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        mHandler.removeCallbacksAndMessages(null);
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);

        if(hasFocus) {
            setImmersiveMode();
        }
    }

    @TargetApi(Build.VERSION_CODES.KITKAT)
    private void setImmersiveMode() {
        mHandler.post(() -> mDecorView.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                | View.SYSTEM_UI_FLAG_FULLSCREEN
                | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY));
    }
}
