package com.example.firstapp.pages;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

import com.example.firstapp.R;
import com.example.firstapp.asynctask.MyDownloadTask;

public class SdCardActivity extends AppCompatActivity implements View.OnClickListener{

    private MyDownloadTask downloadTask;

    private ProgressBar progressBar;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_sd_card);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        this.progressBar = findViewById(R.id.progressbar_download);
        Button btn = findViewById(R.id.btn_startdownload);
        Button btn2 = findViewById(R.id.btn_pausedownload);
        btn.setOnClickListener(this);
        btn2.setOnClickListener(this);
    }

    public void createTask(){
        downloadTask =new MyDownloadTask(this.progressBar);
        downloadTask.execute(1000);
    }

    @Override
    public void onClick(View v) {

        int vid = v.getId();
        if(vid == R.id.btn_startdownload){

        }else if(vid == R.id.btn_pausedownload){

        }

    }
}