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
            #pragma exclude_renderers gles xbox360 ps3

            // Include necessary Unity shader libraries here
            #include "UnityCG.cginc"

            CBUFFER_START(UnityPerMaterial)
            float4 _Tint;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            CBUFFER_END

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
                float result = saturate(dot(float3(0, 1, 0), i.normal));
                return float4(result, result, result, 1) * _Tint;
            }

            ENDCG
        }
    }
}
