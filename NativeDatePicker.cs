using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NativeDialogs
{
    public static class NativeDatePicker
    {
        private static readonly Destructor Finalize = new Destructor();
        private static readonly string DateTimeFormat = "yyyy-MM-ddTHH:mm:sszzzz";

#if UNITY_ANDROID
        private static readonly string pluginName = "me.iboutsikas.nativedialogs.NativeDatePicker";
        private static readonly AndroidJavaObject JavaInstance;

#elif UNITY_IOS
        [DllImport ("__Internal")] 
    
        private static extern string IOS_Speak();
#endif

        public class DatePickerOptions
        {
            public DateTimeOffset SelectedDate = DateTimeOffset.Now;
            public bool Spinner = true;

            public Action<DateTimeOffset> Callback = null;


        }

#if UNITY_ANDROID
        class DatePickerCallback : AndroidJavaProxy
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
#endif
        // Start is called before the first frame update
        static NativeDatePicker()
        {
#if UNITY_ANDROID
            using var jc = new AndroidJavaClass(pluginName);
            JavaInstance = jc.CallStatic<AndroidJavaObject>("getInstance");
#endif
        }

        public static string SanityTest()
        {
#if UNITY_ANDROID
            return JavaInstance.Call<string>("speak");
#elif UNITY_IOS
            return IOS_Speak();
#else
            return "Not supported";
#endif
        }

        public static void ShowDatePicker(DatePickerOptions opts)
        {
#if UNITY_ANDROID
            var dateString = opts.SelectedDate.ToString(DateTimeFormat);

            JavaInstance.Call("showDatePicker", new object[]
            {
            new DatePickerCallback(opts.Callback),
            dateString,
            opts.Spinner
            });
#else
        Debug.Log("This platform is not supported")
#endif
        }

        private sealed class Destructor
        {
            ~Destructor()
            {
#if UNITY_ANDROID

                JavaInstance.Dispose();
#endif
            }
        }
    }
}