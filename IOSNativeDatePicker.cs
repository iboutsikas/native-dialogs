using System;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;

namespace NativeDialogs
{
#if UNITY_IOS && !UNITY_EDITOR
    internal class IOSNativeDatePicker : IDatePicker
    {
        private delegate void DatepickerDelegate(string dateString);
        private static Action<DateTimeOffset> CurrentCallback;

    #region iOS Entrypoints
        [DllImport("__Internal")]
        private static extern void __ND__DatePicker_initialize(DatepickerDelegate @delegate);

        [DllImport("__Internal")]
        private static extern void __ND__DatePicker_popover();
    #endregion

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

        public IOSNativeDatePicker()
        {
            __ND__DatePicker_initialize(delegateMessageReceived);
        }

        public void ShowModal(DatePickerOptions options)
        {
            CurrentCallback = options.Callback;
            __ND__DatePicker_popover();
        }
    }
#endif
}
