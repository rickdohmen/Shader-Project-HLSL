Shader "Custom/FirstLightingShader2"
{
    Properties
    {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Texture", 2D) = "White" {}
    }

        SubShader
    {
        Pass
        {
            Tags
            {
               "LightMode" = "ForwardBase"
            }
                CGPROGRAM

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram

                #include "UnityStandardBRDF.cginc"

                float4 _Tint;
                sampler2D _MainTex;
                float4 _MainTex_ST;


                struct VertexData {
                    float4 position : POSITION;
                    float3 normal : NORMAL;
                    float2 uv : TEXCOORD0;
                };

                struct Interpolators {
                    float4 position : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 normal : TEXCOORD1;
                };

                Interpolators MyVertexProgram(VertexData v) {
                    Interpolators i;
                    i.position = UnityObjectToClipPos(v.position);
                    i.normal = UnityObjectToWorldNormal(v.normal);
                    i.normal = normalize(i.normal);
                    i.uv = TRANSFORM_TEX(v.uv, _MainTex);
                    return i;
                }

                float4 MyFragmentProgram(Interpolators i) : SV_TARGET{
                    i.normal = normalize(i.normal);
                    float3 lightDir = _WorldSpaceLightPos0.xyz;
                    float3 lightColor = _LightColor0.rgb;
                    float3 diffuse = lightColor * DotClamped(lightDir, i.normal);
                    return float4(diffuse, 1);
                }

                ENDCG
        }
    }
}
