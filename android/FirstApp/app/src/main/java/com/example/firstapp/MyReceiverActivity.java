package com.example.firstapp;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.example.firstapp.defines.CommonDefines;
import com.example.firstapp.receiver.MyOrderReceiver01;
import com.example.firstapp.receiver.MyOrderReceiver02;
import com.example.firstapp.receiver.MyOrderReceiver03;
import com.example.firstapp.receiver.MyReceiver01;

public class MyReceiverActivity extends AppCompatActivity implements View.OnClickListener{

    private MyOrderReceiver01 orderReceiver01;
    private MyOrderReceiver02 orderReceiver02;
    private MyOrderReceiver03 orderReceiver03;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_my_receiver);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        Button btn_sendbroad1 = findViewById(R.id.btn_sendbroad_1);
        btn_sendbroad1.setOnClickListener(this);
        Button btn_sendbroad2 = findViewById(R.id.btn_sendbroad_2);
        btn_sendbroad2.setOnClickListener(this);

        dynamicRegisterReceiver();

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        dymamicUnregisterReceiver();
    }

    public void dynamicRegisterReceiver(){

        Log.i(CommonDefines.receiverTag,"MyReceiverActivity dynamicRegisterReceiver");
        // 动态注册广播
        orderReceiver01 = new MyOrderReceiver01();
        orderReceiver02 = new MyOrderReceiver02();
        orderReceiver03 = new MyOrderReceiver03();

        IntentFilter filter1 = new IntentFilter();
        filter1.addAction(CommonDefines.receiverActionRule);
        filter1.setPriority(800);

        IntentFilter filter2 = new IntentFilter();
        filter2.addAction(CommonDefines.receiverActionRule);
        filter2.setPriority(500);

        IntentFilter filter3 = new IntentFilter();
        filter3.addAction(CommonDefines.receiverActionRule);
        filter3.setPriority(100);

        LocalBroadcastManager localBroadcastManager = LocalBroadcastManager.getInstance(this);

//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//
//            Log.i(CommonDefines.receiverTag,"Dynamic register if");
//            registerReceiver(orderReceiver01,filter1, Context.RECEIVER_EXPORTED);
//            registerReceiver(orderReceiver02,filter2, Context.RECEIVER_EXPORTED);
//            registerReceiver(orderReceiver03,filter3,Context.RECEIVER_EXPORTED);
//        }else{
//            Log.i(CommonDefines.receiverTag,"Dynamic register else");
//            registerReceiver(orderReceiver01,filter1);
//            registerReceiver(orderReceiver02,filter2);
//            registerReceiver(orderReceiver03,filter3);
//        }

        localBroadcastManager.registerReceiver(orderReceiver01,filter1);
        localBroadcastManager.registerReceiver(orderReceiver02,filter2);
        localBroadcastManager.registerReceiver(orderReceiver03,filter3);
    }

    public void dymamicUnregisterReceiver(){

        Log.i(CommonDefines.receiverTag,"MyReceiverActivity dymamicUnregisterReceiver");

        unregisterReceiver(orderReceiver01);
        unregisterReceiver(orderReceiver02);
        unregisterReceiver(orderReceiver03);
    }



    @Override
    public void onClick(View v) {

        int vid = v.getId();
        if(vid == R.id.btn_sendbroad_1){

            Log.i(CommonDefines.receiverTag,"MyReceiverActivity click send broad");
            Intent intent = new Intent(MyReceiverActivity.this, MyReceiver01.class);
            intent.putExtra("name","我是个广播内容");
            intent.setAction(CommonDefines.receiverActionRule);
            sendBroadcast(intent);
        }else if(vid == R.id.btn_sendbroad_2){
            Log.i(CommonDefines.receiverTag,"MyReceiverActivity click send broad2");
            MyReceiver01 finalReceiver = new MyReceiver01();

            Intent intent = new Intent();
            intent.setAction(CommonDefines.orderReceiverActionRule);
            intent.setPackage(getPackageName());
//            sendOrderedBroadcast(intent,null);
            sendOrderedBroadcast(intent,null,finalReceiver,null,0,"my name is kk ",null);
        }
    }
}