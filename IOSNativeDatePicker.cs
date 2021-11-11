using System;
using System.Runtime.InteropServices;
using AOT;
using UnityEngine;

namespace NativeDialogs
{
#if UNITY_IOS && !UNITY_EDITOR
    internal class IOSNativeDatePicker : IDatePicker
    {
        private delegate void DatepickerDelegate(long dateUTC);
        private static Action<DateTimeOffset> CurrentCallback;

    #region iOS Entrypoints
        [DllImport("__Internal")]
        private static extern void __ND__DatePicker_initialize(DatepickerDelegate @delegate);

        [DllImport("__Internal")]
        private static extern void __ND__DatePicker_popover(long dateUTC);
    #endregion

        [MonoPInvokeCallback(typeof(DatepickerDelegate))]
        private static void delegateMessageReceived(long dateUTC)
        {
            var date = DateTimeOffset.FromUnixTimeSeconds(dateUTC);
            CurrentCallback?.Invoke(date.ToLocalTime());

        }

        public IOSNativeDatePicker()
        {
            __ND__DatePicker_initialize(delegateMessageReceived);
        }

        public void ShowModal(DatePickerOptions options)
        {
            CurrentCallback = options.Callback;
            __ND__DatePicker_popover(options.SelectedDate.ToUnixTimeSeconds());
        }
    }
#endif
}
