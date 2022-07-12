using System.Collections;
using System.Collections.Generic;
using K13A.BehaviourEditor;
using UnityEditor;
using UnityEngine;



public class GlassEditor : ShaderGUI
{
    public GlassEditor()
    {
        GlassEditorState.fold = new [] {false, false, false};
    }

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        GUI.skin.label.richText = true;
        
        GUILayout.Space(20);
        var titleStyle = new GUIStyle();
        titleStyle.normal.background = null;
        titleStyle.alignment = TextAnchor.MiddleCenter;
        titleStyle.richText = true;
        titleStyle.fontSize = 24;
        titleStyle.fontStyle = FontStyle.Bold;
        GUILayout.Box("<color=white> Glass Shader </color>", titleStyle, GUILayout.ExpandWidth(true), GUILayout.Height(10));
        GUILayout.Space(10);
        titleStyle.alignment = TextAnchor.LowerRight;
        titleStyle.fontSize = 14;
        GUILayout.Box("<color=white> K13A_Labs </color>", titleStyle, GUILayout.ExpandWidth(true), GUILayout.Height(10));
        GUILayout.Space(20);
        
        
        GUILayout.Space(10);
        GlassEditorState.fold[0] = EditorUtil.FoldoutMenuBox("General", GlassEditorState.fold[0], () =>
        {
            GUILayout.Space(10);
            
            EditorUtil.SubMenuBox("Main Texture", () =>
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Main Texture"), properties[1]);
                materialEditor.ShaderProperty(properties[0], "");
            });
            GUILayout.Space(10);
            EditorUtil.SubMenuBox("Normal Texture", () =>
            {
                materialEditor.TexturePropertySingleLine(new GUIContent("Normal"), properties[2]);
                materialEditor.ShaderProperty(properties[3], "");
            });
            GUILayout.Space(10);
        }, new ContentStyle());
        GUILayout.Space(10);
        GlassEditorState.fold[1] = EditorUtil.FoldoutMenuBox("Lighting", GlassEditorState.fold[1], () =>
        {
            GUILayout.Space(10);
            
            EditorUtil.SubMenuBox("General", () =>
            {
                materialEditor.ShaderProperty(properties[5], "Brightness");
                materialEditor.ShaderProperty(properties[6], "Minimum Brightness");
                materialEditor.ShaderProperty(properties[4], "Reflection");
            });
            GUILayout.Space(10);
            
            EditorUtil.SubMenuBox("Speculer lighting", () =>
            {
                materialEditor.ShaderProperty(properties[7], "Use");
                materialEditor.ShaderProperty(properties[8], "");
            });
            
            GUILayout.Space(10);
        }, new ContentStyle());
        GUILayout.Space(10);
        GlassEditorState.fold[2] = EditorUtil.FoldoutMenuBox("Effect", GlassEditorState.fold[2], () =>
        {
            GUILayout.Space(10);
            
            EditorUtil.SubMenuBox("Blur", () =>
            {
                materialEditor.ShaderProperty(properties[9], "Range");
                materialEditor.ShaderProperty(properties[10], "Samples");
                materialEditor.ShaderProperty(properties[11], "Weight Curve");
            });
            
            GUILayout.Space(10);
        }, new ContentStyle());
        
        GUILayout.Space(30);
        GUILayout.Box("<color=white> Copyrightⓒ2022 by KIBA </color>", titleStyle, GUILayout.ExpandWidth(true), GUILayout.Height(10));
        GUILayout.Space(20);
    }

    /*
    public override void OnInspectorGUI ()
    {
        serializedObject.Update ();
        var theShader = serializedObject.FindProperty ("m_Shader"); 
        if (isVisible && !theShader.hasMultipleDifferentValues && theShader.objectReferenceValue != null)
        {
            float controlSize = 64 * 2;

            EditorGUIUtility.LookLikeControls(Screen.width - controlSize - 40);
            
            GUI.skin.label.richText = true;

            EditorGUI.BeginChangeCheck();
            Shader shader = theShader.objectReferenceValue as Shader;
            
            GlassEditorState.fold[0] = EditorUtil.FoldoutMenuBox("General", GlassEditorState.fold[0], () =>
            {
                ShaderPropertyImpl(shader, 0); // Color
            
                GUILayout.Space(20);
            
                EditorUtil.SubMenuBox("Main Texture", () =>
                {
                    ShaderPropertyImpl(shader, 1); // MainTex
                });
                EditorUtil.SubMenuBox("Normal Texture", () =>
                {
                    ShaderPropertyImpl(shader, 2); // NormalTex
                    ShaderPropertyImpl(shader, 3); // NormalRange
                });
                
            }, new ContentStyle());
            
            GlassEditorState.fold[1] = EditorUtil.FoldoutMenuBox("Lighting", GlassEditorState.fold[1], () =>
            {
                ShaderPropertyImpl(shader, 5); // BrightnessRange
                ShaderPropertyImpl(shader, 6); // ReflectionRange
            
                GUILayout.Space(20);
            
                GlassEditorState.fold[2] = EditorUtil.FoldoutMenuBox($"Speculer [{shader.}]", GlassEditorState.fold[2], () =>
                {
                    ShaderPropertyImpl(shader, 0); // Color
            
                    GUILayout.Space(20);
            
                    EditorUtil.SubMenuBox("Main Texture", () =>
                    {
                        ShaderPropertyImpl(shader, 1); // MainTex
                    });
                    EditorUtil.SubMenuBox("Normal Texture", () =>
                    {
                        ShaderPropertyImpl(shader, 2); // NormalTex
                        ShaderPropertyImpl(shader, 3); // NormalRange
                    });
                
                }, new ContentStyle());
                
            }, new ContentStyle());

            for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
            {
                ShaderPropertyImpl(shader, i);
            }

            if (EditorGUI.EndChangeCheck())
                PropertiesChanged ();
        }
    }
    */
}
