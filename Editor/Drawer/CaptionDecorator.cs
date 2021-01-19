
using System;
using UnityEditor;
using UnityEngine;

namespace Shaders.Editor
{
	class CaptionDecorator : MaterialPropertyDrawer
	{
		public static bool enabled = true;
		public static Action<Rect> OnBeforeGUI = null;
		public static Action OnAfterGUI = null;
		
		public CaptionDecorator( string header)
		{
			this.header = header;
		}
		public CaptionDecorator( float headerAsNumber)
		{
			this.header = headerAsNumber.ToString( System.Globalization.CultureInfo.InvariantCulture);
		}
		public override float GetPropertyHeight( MaterialProperty prop, string label, MaterialEditor editor)
		{
			return (enabled != false)? 24 : 0;
		}
		public override void OnGUI( Rect position, MaterialProperty prop, string label, MaterialEditor editor)
		{
			if( enabled != false)
			{
				position.y += 4;
				OnBeforeGUI?.Invoke( position);
				position = EditorGUI.IndentedRect( position);
				GUI.Label( position, header, EditorStyles.boldLabel);
				OnAfterGUI?.Invoke();
			}
		}
		readonly string header;
	}
}
