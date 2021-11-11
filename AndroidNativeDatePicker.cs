using System;
using UnityEngine;

namespace NativeDialogs
{
//#if UNITY_ANDROID && !UNITY_EDITOR
    internal class AndroidNativeDatePicker : IDatePicker
    {
        private static readonly string pluginName = "me.iboutsikas.nativedialogs.NativeDatePicker";

        private readonly AndroidJavaObject JavaInstance;

        public AndroidNativeDatePicker()
        {
            using (var jc = new AndroidJavaClass(pluginName))
            {
                JavaInstance = jc.CallStatic<AndroidJavaObject>("getInstance");
            }
        }

        ~AndroidNativeDatePicker()
        {
            JavaInstance.Dispose();
        }


        public void ShowModal(DatePickerOptions options)
        {
            var seconds = options.SelectedDate.ToUnixTimeSeconds();

            JavaInstance.Call("showDatePicker", new object[]
            {
            new DatePickerCallback(options.Callback),
            seconds,
            options.Spinner
            });
        }




        private class DatePickerCallback : AndroidJavaProxy
        {
            private readonly Action<DateTimeOffset> callback;
            public DatePickerCallback(Action<DateTimeOffset> callback)
                : base($"{pluginName}$NativeDatePickerCallback")
            {
                this.callback = callback;
            }

            public void onDateSet(long dateUTC)
            {
                var date = DateTimeOffset.FromUnixTimeSeconds(dateUTC);

                if (callback != null)
                    callback.Invoke(date.ToLocalTime());

            }
        }
    }
//#endif
}
