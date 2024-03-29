﻿
using UnityEditor;
using UnityEngine;
using System;
using System.Collections.Generic;

namespace Shaders.Editor
{
	public class InspectorGUI : ShaderGUI
	{
		protected virtual void OnBeginGUI( MaterialEditor materialEditor)
		{
		}
		protected virtual bool OnPropertyVerify( MaterialProperty property)
		{
			return (property.flags & (MaterialProperty.PropFlags.HideInInspector | MaterialProperty.PropFlags.PerRendererData)) == 0;
		}
		protected virtual void OnPropertiesGUI( MaterialEditor materialEditor, List<MaterialProperty> properties)
		{
			foreach( var property in properties)
			{
				materialEditor.ShaderProperty( property, property.displayName);
			}
		}
		protected virtual void OnFotterGUI( MaterialEditor materialEditor, List<MaterialProperty> properties)
		{
		}
		public override void OnGUI( MaterialEditor materialEditor, MaterialProperty[] properties)
		{
			var materialProperties = new List<MaterialProperty>();
			MaterialProperty property;
			bool statusValid = false;
			int indentCount = 0;
			int i0, i1;
			
			var materialGroupTypes = MaterialGroupTypes;
			if( materialGroupTypes != null)
			{
				if( materialGroups.Length != materialGroupTypes.Length)
				{
					materialGroups = new MaterialPropertyGroup[ materialGroupTypes.Length];
				}
				for( i0 = 0; i0 < materialGroups.Length; ++i0)
				{
					if( materialGroupTypes[ i0] != null)
					{
						if( materialGroups[ i0] == null
						||	materialGroups[ i0].GetType() != materialGroupTypes[ i0])
						{
							materialGroups[ i0] = Activator.CreateInstance( materialGroupTypes[ i0]) as MaterialPropertyGroup;
						}
						materialGroups[ i0]?.ClearProperty();
					}
				}
			}
			for( i0 = 0; i0 < statusGroups.Length; ++i0)
			{
				if( statusGroups[ i0] == null)
				{
					statusGroups[ i0] = Activator.CreateInstance( kStatusTypes[ i0]) as MaterialPropertyGroup;
				}
				statusGroups[ i0].ClearProperty();
			}
			OnBeginGUI( materialEditor);
			
			for( i1 = 0; i1 < properties.Length; ++i1)
			{
				property = properties[ i1];
				
				for( i0 = 0; i0 < statusGroups.Length; ++i0)
				{
					if( (statusGroups[ i0]?.SetProperty( property) ?? false) != false)
					{
						break;
					}
				}
				if( i0 < statusGroups.Length)
				{
					statusValid = true;
					continue;
				}
				for( i0 = 0; i0 < materialGroups.Length; ++i0)
				{
					if( (materialGroups[ i0]?.SetProperty( property) ?? false) != false)
					{
						break;
					}
				}
				if( i0 < materialGroups.Length)
				{
					continue;
				}
				if( OnPropertyVerify( property) != false)
				{
					materialProperties.Add( property);
				}
			}
			EditorGUIUtility.fieldWidth = 64; //EditorGUI.kObjectFieldThumbnailHeight;
			EditorGUIUtility.labelWidth = EditorGUIUtility.currentViewWidth * 0.5f;
			if( EditorGUIUtility.labelWidth < 204)
			{
				EditorGUIUtility.labelWidth = EditorGUIUtility.currentViewWidth - 204;
			}
			CaptionDecorator.OnBeforeGUI = (position) =>
			{
				if( indentCount > 0)
				{
					position.height = 1;
					EditorGUI.DrawRect( position, Color.gray);
					EditorGUI.indentLevel -= indentCount;
					indentCount = 0;
				}
			};
			CaptionDecorator.OnAfterGUI = () =>
			{
				++EditorGUI.indentLevel;
				++indentCount;
			};
			OnPropertiesGUI( materialEditor, materialProperties);
			
			for( i0 = 0; i0 < materialGroups.Length; ++i0)
			{
				materialGroups[ i0]?.OnGUI( materialEditor);
			}
			if( indentCount > 0)
			{
				EditorGUI.indentLevel -= indentCount;
				indentCount = 0;
			}
			CaptionDecorator.OnBeforeGUI = null;
            CaptionDecorator.OnAfterGUI = null;
			CaptionDecorator.enabled = false;
			
			if( statusValid != false)
			{
				EditorGUILayout.Space();
				GUILayout.Box( string.Empty, GUILayout.ExpandWidth( true), GUILayout.Height( 1));
				
				for( i0 = 0; i0 < statusGroups.Length; ++i0)
				{
					statusGroups[ i0]?.OnGUI( materialEditor);
				}
				GUILayout.Box( string.Empty, GUILayout.ExpandWidth( true), GUILayout.Height( 1));
			}
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			
			if( UnityEngine.Rendering.SupportedRenderingFeatures.active.editableMaterialRenderQueue != false)
			{
                materialEditor.RenderQueueField();
            }
            materialEditor.EnableInstancingField();
            materialEditor.DoubleSidedGIField();
            OnFotterGUI( materialEditor, materialProperties);
            CaptionDecorator.enabled = true;
		}
		protected static void RemoveUnusedProperties( Material material)
		{
			if( material != null)
			{
				var serializedObject = new SerializedObject( material);
				if( serializedObject != null)
				{
					int removeTexEnvCount = RemoveProperties( material, serializedObject, "m_SavedProperties.m_TexEnvs", false);
					int removeColorCount = RemoveProperties( material, serializedObject, "m_SavedProperties.m_Colors", true);
					int removeFloatCount = RemoveProperties( material, serializedObject, "m_SavedProperties.m_Floats", true);
					int removeIntCount = RemoveProperties( material, serializedObject, "m_SavedProperties.m_Ints", true);
					
					if( removeTexEnvCount > 0 || removeColorCount > 0 || removeFloatCount > 0 || removeIntCount > 0)
					{
						serializedObject.ApplyModifiedProperties();
					}
				}
			}
		}
		protected static int RemoveProperties( Material material, SerializedObject serializedObject, string propertyPath, bool forced)
		{
			var arrayProperty = serializedObject.FindProperty( propertyPath);
			int removeCount = 0;
			
			if( (arrayProperty?.isArray ?? false) != false)
			{
				for( int i0 = arrayProperty.arraySize - 1; i0 >= 0; --i0)
				{
					var property = arrayProperty.GetArrayElementAtIndex( i0);
					var propertyName = property.FindPropertyRelative( "first").stringValue; //return property.displayName;
					
					if( forced != false || material.HasProperty( propertyName) == false)
					{
						arrayProperty.DeleteArrayElementAtIndex( i0);
						++removeCount;
					}
				}
			}
			return removeCount;
		}
		protected virtual Type[] MaterialGroupTypes
		{
			get{ return null; }
		}
		static readonly Type[] kStatusTypes = new Type[]
		{
			typeof( RenderingStatus),
			typeof( BlendStatus),
			typeof( BlendStatusAdd),
			typeof( DepthStencilStatus),
		};
		MaterialPropertyGroup[] statusGroups = new MaterialPropertyGroup[ kStatusTypes.Length];
		MaterialPropertyGroup[] materialGroups = new MaterialPropertyGroup[ 0];
	}
}
