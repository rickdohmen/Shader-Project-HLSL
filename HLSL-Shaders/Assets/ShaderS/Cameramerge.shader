Shader "Unlit/CameraMerge"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _FirstTex ("First Texture", 2D) = "white" {}
        _SecondTex ("Second Texture", 2D) = "white" {}

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        //Blend SrcAlpha OneMinusSrcAlpha
        //ColorMask on
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _FirstTex ,_SecondTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_FirstTex, i.uv);
                fixed4 blend = tex2D(_SecondTex, i.uv);
                
                //return float4(blend.a, 0, 0, 1);
                return lerp(col, blend, blend.a);

            }
            ENDCG
        }
    }
}
