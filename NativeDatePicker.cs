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
        private static IDatePicker s_DatePicker;

        static NativeDatePicker()
        {
#if UNITY_IOS && !UNITY_EDITOR
            s_DatePicker = new IOSNativeDatePicker();
#elif UNITY_ANDROID && !UNITY_EDITOR
            s_DatePicker = new AndroidNativeDatePicker();
#else
            s_DatePicker = new DefaultDatePicker();
#endif
        }

        public static void ShowModalDatepicker(DatePickerOptions opts)
        {
            s_DatePicker.ShowModal(opts);
        }
    }
}