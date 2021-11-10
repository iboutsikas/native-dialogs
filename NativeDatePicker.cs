using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;

namespace NativeDialogs
{
    public static class NativeDatePicker
    {
        private static readonly Destructor Finalize = new Destructor();

#if UNITY_ANDROID
        private static readonly string DateTimeFormat = "yyyy-MM-ddTHH:mm:sszzzz";

        private static readonly string pluginName = "me.iboutsikas.nativedialogs.NativeDatePicker";
        private static readonly AndroidJavaObject JavaInstance;

#elif UNITY_IOS
        private static Action<DateTimeOffset> CurrentCallback;

        [DllImport ("__Internal")]    
        private static extern string _TAG_NativeDatePicker_getGreeting();

        [DllImport("__Internal")]
        private static extern string _TAG_NativeDatePicker_initialize(
            float x,
            float y,
            float width,
            float height);

        [DllImport("__Internal")]
        private static extern string _TAG_NativeDatePicker_setPosition(
            float x,
            float y,
            float width,
            float height);

        [DllImport("__Internal")]
        private static extern void _TAG_NativeDatePicker_popover(DatepickerDelegate callback);

        private delegate void DatepickerDelegate(string dateString);

        [MonoPInvokeCallback(typeof(DatepickerDelegate))]
        private static void delegateMessageReceived(string dateString)
        {
            Debug.Log($"Datestring received: {dateString}");
            if (DateTimeOffset.TryParse(dateString, out var date))
            {
                CurrentCallback?.Invoke(date.ToLocalTime());
            }
            else
            {
                Debug.Log("Failed to parse datestring");
            }    
        }

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
#if UNITY_ANDROID && !UNITY_EDITOR
            return JavaInstance.Call<string>("speak");
#elif UNITY_IOS && !UNITY_EDITOR
            return _TAG_NativeDatePicker_getGreeting();
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
            Debug.Log("This platform is not supported");
#endif
        }

        public static void SetPosition(Rect rect)
        {
            _TAG_NativeDatePicker_setPosition(
                rect.position.x,
                rect.position.y,
                rect.width,
                rect.height
                );
        }

        public static void ShowModalDatepicker(DatePickerOptions opts)
        {
#if UNITY_ANDROID
            ShowDatePicker(opts);
#elif UNITY_IOS
            CurrentCallback = opts.Callback;
            _TAG_NativeDatePicker_popover(delegateMessageReceived);
#else
        Debug.Log("This platform is not supported");
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