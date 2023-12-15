// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader"Custom/First Lighting Shader"
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

                CGPROGRAM
                
                #pragma target 3.0

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram

                #include "My Lighting.cginc"

                
                ENDCG
            }
            
            Pass
            {
                Blend One One
                ZWrite off
                
                CGPROGRAM
                
                #pragma target 3.0

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram

                #define POINT

                #include "My Lighting.cginc"

                
                ENDCG
            }
        }
}
