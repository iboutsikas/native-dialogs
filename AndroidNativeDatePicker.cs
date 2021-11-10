using System;
using UnityEngine;

namespace NativeDialogs
{
#if UNITY_ANDROID && !UNITY_EDITOR
    internal class AndroidNativeDatePicker : IDatePicker
    {
        private static readonly string DateTimeFormat = "yyyy-MM-ddTHH:mm:sszzzz";
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
            var dateString = options.SelectedDate.ToString(DateTimeFormat);

            JavaInstance.Call("showDatePicker", new object[]
            {
            new DatePickerCallback(options.Callback),
            dateString,
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

            public void onDateSet(string dateString)
            {
                if (DateTimeOffset.TryParse(dateString, out var date))
                {
                    if (callback != null)
                        callback.Invoke(date);
                }
                else
                {
                    Debug.Log($"Failed to parse {dateString} from Java.");
                }

            }
        }
    }
#endif
}
