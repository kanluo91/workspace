package com.example.firstapp.service;

import android.app.Service;
import android.content.Intent;
import android.os.Binder;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.example.firstapp.defines.CommonDefines;

public class MyBindService extends Service {


    // 内部类
    public class MyBinder extends Binder{

        public MyBinder(){
            Log.i(CommonDefines.serviceTag,"内部类MyBinder  构造方法");
        }

        public MyBindService getService(){
            return MyBindService.this;
        }
    }

    // 内部类的实例对象
    private MyBinder myBinder = new MyBinder();

    @Override
    public void onCreate() {
        super.onCreate();
        Log.i(CommonDefines.serviceTag,"MyBindService onCreate");
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        Log.i(CommonDefines.serviceTag,"MyBindService onDestroy");
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        Log.i(CommonDefines.serviceTag,"MyBindService onBind");
        return myBinder;
    }

    @Override
    public boolean onUnbind(Intent intent) {
        Log.i(CommonDefines.serviceTag,"MyBindService onUnbind");
        return super.onUnbind(intent);
    }
}
