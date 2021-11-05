package me.iboutsikas.nativedialogs;

import android.app.DatePickerDialog;
import android.util.Log;
import android.widget.DatePicker;

import com.unity3d.player.UnityPlayer;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

public class NativeDatePicker {

    public interface NativeDatePickerCallback {
        void onDateSet(String dateString);
    }

    private static final NativeDatePicker s_Instance = new NativeDatePicker();
    private static final String LOGTAG = "NativeDatePicker";

    private static final String DefaultDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX";
    private static final SimpleDateFormat SDF = new SimpleDateFormat(DefaultDateFormat, Locale.getDefault());

    public static NativeDatePicker getInstance() { return s_Instance; }

    private static Date parseDate(String dateString)
    {
        if (dateString == null)
            return new Date();

        try {
            return SDF.parse(dateString);
        }

        catch (ParseException e) {
            e.printStackTrace();
            return new Date();
        }
    }

    private DatePickerDialog dialog;

    private NativeDatePicker() {

    }


    public void showDatePicker(final NativeDatePickerCallback callback, String dateString, boolean isSpinner) {

        Date date = parseDate(dateString);

        Calendar calendar = new GregorianCalendar();
        calendar.setTime(date);

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

                Date d = cal.getTime();
                String str = SDF.format(d);

                callback.onDateSet(str);
            }
        });

        dialog.show();
    }

    public String speak() {
        Log.i(LOGTAG, "Hi from the Java side.");
        return "Hi from the Java side.";
    }
}
