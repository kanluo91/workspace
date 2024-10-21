package com.example.firstapp;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.activity.EdgeToEdge;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;

public class MainActivity2 extends AppCompatActivity implements View.OnClickListener{


    Button btn1,btn2,btn3;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        EdgeToEdge.enable(this);
        setContentView(R.layout.activity_main2);
        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main2), (v, insets) -> {
            Insets systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars());
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom);
            return insets;
        });

        Intent intent = this.getIntent();

        btn1 = findViewById(R.id.btn_back);
        btn2 = findViewById(R.id.btn_back2);
        btn3 = findViewById(R.id.btn_back3);

        btn1.setOnClickListener(this);
        btn2.setOnClickListener(this);
        btn3.setOnClickListener(this);

    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    @Override
    public void onClick(View v) {
        if(v.getId() == R.id.btn_back3){

            finish();

        }else if(v.getId() == R.id.btn_back){

            Intent intent = new Intent(MainActivity2.this,MainActivity.class);
            intent.putExtra("name","kkluo-haha");
            intent.putExtra("age",19);
            setResult(MainActivity2.RESULT_OK,intent);
            finish();

        }else if(v.getId() == R.id.btn_back2) {
            Intent intent = new Intent(MainActivity2.this,MainActivity.class);
            intent.putExtra("name","kkluo");
            intent.putExtra("age",18);
            setResult(123,intent);
            finish();
        }
    }
}