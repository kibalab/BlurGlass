// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "K13A/BlurGlass"
{
    Properties {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Reflection ("Reflection Range", Range(0, 1)) = 0.3
        _Size ("Size", Range(0, 300)) = 1
        _Texel ("Blur Texel", Range(1, 300)) = 1
        _BCurve ("Blur Curve", Range(0.1, 100)) = 0.1
    }
       
    Category {
    
        Tags { "Queue"="Transparent" "IgnoreProjector"="False" "RenderType"="Opaque" }

        SubShader {
    

            Pass { // Original Pass behind Blur
                Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
                ZWrite Off
                Blend SrcAlpha OneMinusSrcAlpha
                Cull front 
                LOD 100

                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #include "./cginc/OriginalPass.cginc"
                ENDCG
            }

            Pass { //Reflect Pass
                Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
                ZWrite Off
                Blend SrcAlpha OneMinusSrcAlpha
                Cull Back 
                LOD 100

                CGPROGRAM

                #pragma target 3.0

                #pragma vertex vert
                #pragma fragment frag
                #include "UnityCG.cginc"
                
                fixed _Reflection;
                fixed4 _Color;

                struct v2f{
                    float4 pos : SV_POSITION;
                    float3 coord: TEXCOORD0;
                    float3 viewDir : TEXCOORD1;
                };

                v2f vert(appdata_base v){
                    v2f o;

                    float4x4 modelMatrix = unity_ObjectToWorld;
                    float4x4 modelMatrixInverse = unity_WorldToObject;

                    o.viewDir = mul(modelMatrix, v.vertex).xyz
                    - _WorldSpaceCameraPos;
                    o.coord = normalize(mul(float4(v.normal, 0.0), modelMatrixInverse).xyz);

                    o.pos = UnityObjectToClipPos(v.vertex);

                    return o;
                }

                float4 frag(v2f i) : COLOR{
                    fixed3 wr = reflect(i.viewDir, normalize(i.coord));
                    float4 finalColor = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, wr) * unity_SpecCube0_HDR.r;
                    return finalColor * _Reflection;
                }

                ENDCG
            }

            // Horizontal blur
            GrabPass {                     
                Tags { "LightMode" = "Always" }
            }

            Pass {
                Tags { "LightMode" = "Always" }
            
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
            
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
            
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
                };
            
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    #if UNITY_UV_STARTS_AT_TOP
                        float scale = -1.0;
                    #else
                        float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
            
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                float _Size;
                float _Texel;
                float _BCurve;
                
                half4 BlurLayer(v2f i, float weight, float kernelx, sampler2D Texture)
                {
                    return tex2Dproj( Texture, UNITY_PROJ_COORD(float4(i.uvgrab.x + _GrabTexture_TexelSize.x * kernelx*_Size, i.uvgrab.y, i.uvgrab.z, i.uvgrab.w))) * weight;
                }
                
                float CalculateLayerWeightBuIndex(float index)
                {
                    return (cos(index * 3.141592 / _Texel) / _BCurve + 0.5) / _Texel;
                }
                
                half4 Blur(v2f i, sampler2D Texture)
                {
                    half4 sum = half4(0,0,0,0);
                                        
                    fixed blur_layerWeight = 1 / _Texel / 2;

                    for(int j = 0; j < _Texel; j++)
                    {
                        sum += BlurLayer(i, CalculateLayerWeightBuIndex(j), -1 * (j / _Texel), Texture);
                    }
                    for(int j = 0; j < _Texel; j++)
                    {
                        sum += BlurLayer(i, CalculateLayerWeightBuIndex(j), (j / _Texel), Texture);
                    }
                    return sum;
                }
            
                half4 frag( v2f i ) : COLOR {
                    return Blur(i, _GrabTexture);
                }
                ENDCG
            }

            // Vertical blur
            GrabPass {                         
                Tags { "LightMode" = "Always" }
            }

            Pass {
                Tags { "LightMode" = "Always" }
            
                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag
                #pragma fragmentoption ARB_precision_hint_fastest
                #include "UnityCG.cginc"
            
                struct appdata_t {
                    float4 vertex : POSITION;
                    float2 texcoord: TEXCOORD0;
                };
            
                struct v2f {
                    float4 vertex : POSITION;
                    float4 uvgrab : TEXCOORD0;
                };
            
                v2f vert (appdata_t v) {
                    v2f o;
                    o.vertex = UnityObjectToClipPos(v.vertex);
                    #if UNITY_UV_STARTS_AT_TOP
                        float scale = -1.0;
                    #else
                        float scale = 1.0;
                    #endif
                    o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y*scale) + o.vertex.w) * 0.5;
                    o.uvgrab.zw = o.vertex.zw;
                    return o;
                }
            
                sampler2D _GrabTexture;
                float4 _GrabTexture_TexelSize;
                float _Size;
                float _Texel;
                float _BCurve;
                
                half4 BlurLayer(v2f i, float weight, float kernely, sampler2D Texture)
                {
                    return tex2Dproj( Texture, UNITY_PROJ_COORD(float4(i.uvgrab.x, i.uvgrab.y + _GrabTexture_TexelSize.y * kernely*_Size, i.uvgrab.z, i.uvgrab.w))) * weight;
                }
                
                float CalculateLayerWeightBuIndex(float index)
                {
                    return (cos(index * 3.141592 / _Texel) / _BCurve + 0.5) / _Texel;
                }
            
                half4 Blur(v2f i, sampler2D Texture)
                {
                    half4 sum = half4(0,0,0,0);
                                        
                    fixed blur_layerWeight = 1 / _Texel / 2;

                    for(int j = 0; j < _Texel; j++)
                    {
                        sum += BlurLayer(i, CalculateLayerWeightBuIndex(j), -1 * (j / _Texel), Texture);
                    }
                    for(int j = 0; j < _Texel; j++)
                    {
                        sum += BlurLayer(i, CalculateLayerWeightBuIndex(j), (j / _Texel), Texture);
                    }
                    return sum;
                }
            
                half4 frag( v2f i ) : COLOR {
                    return Blur(i, _GrabTexture);
                }
                ENDCG
            }
        }

        
    }
}
