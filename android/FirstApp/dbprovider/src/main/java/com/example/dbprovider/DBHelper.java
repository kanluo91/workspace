package com.example.dbprovider;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

public class DBHelper extends SQLiteOpenHelper {

    private  static final String kDBName = "kdatabase.db";
    private  static final int kDBVersion = 1;
    public static final String kTableName = "user";


    public DBHelper(@Nullable Context context, @Nullable String name, @Nullable SQLiteDatabase.CursorFactory factory, int version) {
        super(context, kDBName, factory, kDBVersion);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {

        String sqlString = "create table if not exists " + kTableName +
                " (uid INTEGER PRIMARY KEY AUTOINCREMENT," +
                " name VARCHAR(30), " +
                " age INTEGER, " +
                " score DOUBLE)";

        db.execSQL(sqlString);

    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }
}
