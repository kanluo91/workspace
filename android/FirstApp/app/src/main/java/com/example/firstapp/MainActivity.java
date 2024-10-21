package com.example.firstapp;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Switch;
import android.widget.TextView;

import androidx.activity.EdgeToEdge;
import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultCallback;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.firstapp.defines.CommonDefines;
import com.example.firstapp.receiver.MyReceiver01;
import com.example.firstapp.service.MyBindService;
import com.example.firstapp.service.MyService01;

public class MainActivity extends AppCompatActivity implements View.OnClickListener{


    TextView tv_callback;
    Button btn1,btn2,btn3;
    Button btn_startservice,btn_stopservice,btn_bindservice,btn_unbindservice;

    // 跳转Activity 带回调
    ActivityResultLauncher<Intent> launcher;

    // bind service
    ServiceConnection serviceConnection;
    MyBindService.MyBinder myBinder;

    @SuppressLint("MissingInflatedId")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });
        configActivityUI();
        configServiceUI();
        configReceiverUI();
    }


    public void configActivityUI(){
        launcher = registerForActivityResult(new ActivityResultContracts.StartActivityForResult(), new ActivityResultCallback<ActivityResult>() {
            @Override
            public void onActivityResult(ActivityResult result) {

                Log.i("[KK]","onActivityResult");
                if(result != null){
                    Intent intent = result.getData();
                    if(intent != null && result.getResultCode() == Activity.RESULT_OK){

                        String name = intent.getStringExtra("name");
                        int age = intent.getIntExtra("age",-1);
                        String ageStr = String.valueOf(age);
                        Log.i("[KK]",name);
                        Log.i("[KK]",ageStr);
                    }
                }
            }
        });

        tv_callback = findViewById(R.id.tv_showcallback);
        btn1 = findViewById(R.id.btn1);
        btn2 = findViewById(R.id.btn2_withresult);
        btn3 = findViewById(R.id.btn3_withresult);

        tv_callback.setText("四大组件");
        btn1.setOnClickListener(this);
        btn2.setOnClickListener(this);
        btn3.setOnClickListener(this);
    }

    public void configServiceUI(){

        btn_startservice = findViewById(R.id.btn1_startservice);
        btn_stopservice = findViewById(R.id.btn1_stopservice);
        btn_bindservice = findViewById(R.id.btn1_bindservice);
        btn_unbindservice = findViewById(R.id.btn1_unbindservice);

        btn_startservice.setOnClickListener(this);
        btn_stopservice.setOnClickListener(this);
        btn_bindservice.setOnClickListener(this);
        btn_unbindservice.setOnClickListener(this);

        // 连接服务
        serviceConnection = new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName name, IBinder service) {

                if(service instanceof MyBindService.MyBinder){
                    myBinder = (MyBindService.MyBinder) service;
                }
            }

            @Override
            public void onServiceDisconnected(ComponentName name) {

            }
        };

    }

    public void configReceiverUI(){
        Button gotoReceiveBtn = findViewById(R.id.btn_goto_receiver);
        gotoReceiveBtn.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {

        int viewId = v.getId();

        if(v.getId() == R.id.btn1){
            Log.i("[点击事件]","[Click]点击了按钮btn0");
                /*
                参数0： 打开的源是谁
                参数1： 要打开哪个页面
                 */
            Intent intent = new Intent(MainActivity.this, MainActivity2.class);
            startActivity(intent);
        }else if(v.getId() == R.id.btn2_withresult){
            Intent intent = new Intent(MainActivity.this,MainActivity2.class);
            startActivityForResult(intent,123);
        }else if(v.getId() == R.id.btn3_withresult){
            Intent intent = new Intent(MainActivity.this,MainActivity2.class);
            launcher.launch(intent);
        }else if(viewId == R.id.btn1_startservice){
            Log.i(CommonDefines.serviceTag,"MyService01 startService");
            Intent intent = new Intent(MainActivity.this, MyService01.class);
            startService(intent);
        }else if(viewId == R.id.btn1_stopservice){
            Log.i(CommonDefines.serviceTag,"MyService01 stopService");
            Intent intent = new Intent(MainActivity.this, MyService01.class);
            stopService(intent);
        }else if(viewId == R.id.btn1_bindservice){
            Log.i(CommonDefines.serviceTag,"MyBindService bindService");
            Intent intent = new Intent(MainActivity.this, MyBindService.class);
            bindService(intent,serviceConnection, Context.BIND_AUTO_CREATE);
        }else if(viewId == R.id.btn1_unbindservice){
            unbindService(serviceConnection);
        }else if(viewId == R.id.btn_goto_receiver){
            Log.i(CommonDefines.receiverTag,"MyReceiverActivity startActivity");
            Intent intent = new Intent(MainActivity.this, MyReceiverActivity.class);
            startActivity(intent);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        Log.i("[KK]","onActivityResult");

        if(data == null){
            Log.i("[KK]","get data null");
            return;
        }

        String name = data.getStringExtra("name");
        int age = data.getIntExtra("age",-1);
        String ageStr = String.valueOf(age);

        Log.i("[KK]",name);
        Log.i("[KK]",ageStr);
    }
}
