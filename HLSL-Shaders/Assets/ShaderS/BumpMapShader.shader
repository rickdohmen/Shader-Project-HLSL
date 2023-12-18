Shader"Custom/Bump Map"
{
    Properties
    {
        _Tint("Tint", Color) = (1, 1, 1, 1)
        _MainTex("Albedo", 2D) = "White" {}
        [NoScaleOffset] _NormalMap("Normals", 2D) = "bump" {}
        [Gamma]_Metallic("Metallic", Range(0, 1)) = 0
        _Smoothness("Smoothness", Range(0,1)) = 0.5
    }

        SubShader
        {
            Pass
            {

                CGPROGRAM

                #pragma target 3.0

                #pragma multi_compile _ VERTEXLIGHT_ON

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram

                #pragma FORWARD_BASE_PASS

                #include "My BumpMap.cginc"


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
                #pragma multi_compile fwdadd


                #include "My BumpMap.cginc"


                ENDCG
            }
        }
}