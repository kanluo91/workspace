package com.example.firstapp.asynctask;

import android.os.AsyncTask;
import android.widget.ProgressBar;

public class MyDownloadTask extends AsyncTask {

    private ProgressBar progressBar;

    public MyDownloadTask(ProgressBar progressBar){
        super();
        this.progressBar = progressBar;
    }

    @Override
    protected void onPreExecute() {
        this.progressBar.setProgress(0);
    }

    @Override
    protected Object doInBackground(Object[] objects) {
        return null;
    }

    @Override
    protected void onProgressUpdate(Object[] values) {
        Object value = values[0];
        int progress = Integer.parseInt(value.toString());
        this.progressBar.setProgress(progress);

    }
}
