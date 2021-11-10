using System;
using UnityEngine;

namespace NativeDialogs
{
    internal class DefaultDatePicker : IDatePicker
    {
        public void ShowModal(DatePickerOptions options)
        {
            Debug.Log("Platform not supported");
        }
    }
}