package com.example.firstapp.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.example.firstapp.defines.CommonDefines;

public class MyOrderReceiver02 extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        String name = getResultData();
        Log.i(CommonDefines.receiverTag,"MyOrderReceiver02 onReceive" + name);
        abortBroadcast();
    }
}
