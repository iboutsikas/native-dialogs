using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace NativeDialogs
{
    public class DatePickerComponent : MonoBehaviour
    {
        private RectTransform rectTransform;

        [Range(0, 1)]
        public float TopOffset = 0.0f;

        [Range(0, 1)]
        public float LeftOffset = 0.0f;

        private void Awake()
        {
            rectTransform = GetComponent<RectTransform>();

            if (rectTransform == null)
            {
                Debug.Log($"[DatePickerComponent] No RectTransform found. This component should be attached to a ui element");
            }
        }

        private void Start()
        {
#if UNITY_IOS
            Show();
#endif
        }

        public void Show()
        {
            var opts = new NativeDatePicker.DatePickerOptions();

            var rect = rectTransform.GetScreenRect();
            rect.x += (rect.width * LeftOffset);
            rect.y += (rect.height * TopOffset);

            opts.DatePickerRect = rect;

            NativeDatePicker.ShowDatePicker(opts);
        }
    }
}
