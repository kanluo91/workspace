package com.example.firstapp.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.example.firstapp.defines.CommonDefines;

public class MyOrderReceiver01 extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        String action = intent.getAction();
        String data = getResultData();
        Log.i(CommonDefines.receiverTag,"MyOrderReceiver01 onReceive" + data);
        setResultData(data + "123");
    }
}
