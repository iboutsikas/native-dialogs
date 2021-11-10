using UnityEngine;

namespace NativeDialogs
{
    public static class RectTransformExtensions
    {
        public static Rect GetScreenRect(this RectTransform rectTransform)
        {
            Rect r = rectTransform.rect;

            Vector2 zero = rectTransform.localToWorldMatrix.MultiplyPoint(new Vector3(r.x, r.y));
            Vector2 one = rectTransform.localToWorldMatrix.MultiplyPoint(new Vector3(r.x + r.width, r.y + r.height));

            return new Rect(zero.x, Screen.height - one.y, one.x, Screen.height - zero.y);
            //Vector3[] corners = new Vector3[4];
            //rectTransform.GetWorldCorners(corners);

            //float xMin = float.PositiveInfinity;
            //float yMin = float.PositiveInfinity;

            //float xMax = float.NegativeInfinity;
            //float yMax = float.NegativeInfinity;

            //foreach (var corner in corners)
            //{
            //    var screenPos = RectTransformUtility.WorldToScreenPoint(null, corner);

            //    if (screenPos.x < xMin)
            //        xMin = screenPos.x;

            //    if (screenPos.x > xMax)
            //        xMax = screenPos.x;

            //    if (screenPos.y < yMin)
            //        yMin = screenPos.y;

            //    if (screenPos.y > yMax)
            //        yMax = screenPos.y;
            //}

            //return new Rect(xMin, Screen.height - yMax, xMax - xMin, yMax - yMin);
        }
    }
}