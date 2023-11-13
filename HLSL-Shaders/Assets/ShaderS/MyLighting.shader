Shader "Custom/My Lighting"
{
    Properties
    {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "White" {}
        [Gamma]_Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0,1)) = 0.5
    }

        SubShader
    {
        Pass
        {
            Tags{
                "LightMode" = "ForwardBase"
            }
                CGPROGRAM
                
                #pragma target 3.0

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram

                #include "My Lighting.cginc"

                #if !define(MY_LIGHTING_INCLUDED)
                #define MY_LIGHTING-INCLUDED
                
                #include "UnityPBSLighting.cginc"

                #endif
                
                ENDCG
        }
    }
}
