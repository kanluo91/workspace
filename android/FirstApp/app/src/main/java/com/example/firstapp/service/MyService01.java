package com.example.firstapp.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.example.firstapp.defines.CommonDefines;

public class MyService01 extends Service {

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(CommonDefines.serviceTag,"MyService01 onCreate");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(CommonDefines.serviceTag,"MyService01 onDestroy");
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

}
