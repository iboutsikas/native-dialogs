using System;

namespace NativeDialogs
{
    public class DatePickerOptions
    {
        public DateTimeOffset SelectedDate = DateTimeOffset.Now;
        public bool Spinner = true;

        public Action<DateTimeOffset> Callback = null;


    }
}

