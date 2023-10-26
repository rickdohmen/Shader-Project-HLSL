Shader "Custom/FirstShader"
{
    SubShader
    {
        Pass
        {
                CGPROGRAM

                #pragma vertex MyVertexProgram
                #pragma fragment MyFragmentProgram



                void MyVertexProgram() 
                {
                    
                }

                void MyFragmentProgram()
                {

                }

                ENDCG
        }
    }
}
