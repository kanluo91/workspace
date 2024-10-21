package com.example.firstapp.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.example.firstapp.defines.CommonDefines;

public class MyReceiver01 extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.i(CommonDefines.receiverTag,"MyReceiver01 onReceive");
        if(action != null && action.equals(CommonDefines.receiverActionRule)){
            Log.i(CommonDefines.receiverTag,"MyReceiver01 onReceive action MyFilterRules");
        }
    }
}
