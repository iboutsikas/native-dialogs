package me.iboutsikas.nativedialogs;

import android.app.DatePickerDialog;
import android.util.Log;
import android.widget.DatePicker;

import com.unity3d.player.UnityPlayer;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

public class NativeDatePicker {

    public interface NativeDatePickerCallback {
        void onDateSet(long dateUTC);
    }

    private static final NativeDatePicker s_Instance = new NativeDatePicker();
    private static final String LOGTAG = "NativeDatePicker";

    public static NativeDatePicker getInstance() { return s_Instance; }

    private DatePickerDialog dialog;

    private NativeDatePicker() {

    }


    public void showDatePicker(final NativeDatePickerCallback callback, long dateUTC, boolean isSpinner) {

        Calendar calendar = new GregorianCalendar();
        calendar.setTimeInMillis(dateUTC * 1000);

        if (dialog != null)
            dialog.dismiss();

        int style = isSpinner ? R.style.MySpinnerDatePickerStyle : R.style.MyCalendarDatePickerStyle;

        dialog = new DatePickerDialog(UnityPlayer.currentActivity,
                style,
                null,
                calendar.get(Calendar.YEAR),
                calendar.get(Calendar.MONTH),
                calendar.get(Calendar.DAY_OF_MONTH));

        dialog.setOnDateSetListener(new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.YEAR, year);
                cal.set(Calendar.MONTH, month);
                cal.set(Calendar.DAY_OF_MONTH, dayOfMonth);

                callback.onDateSet(cal.getTimeInMillis() / 1000);
            }
        });

        dialog.show();
    }

    public String speak() {
        Log.i(LOGTAG, "Hi from the Java side.");
        return "Hi from the Java side.";
    }
}
