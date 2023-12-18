﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#if !defined(MY_LIGHTING_INCLUDED)
#define MY_LIGHTING_INCLUDED

#include "AutoLight.cginc"
#include "UnityPBSLighting.cginc"

float4 _Tint;
sampler2D _MainTex;
float4 _MainTex_ST;

float _Metallic;
float _Smoothness;

struct VertexData {
	float4 position : POSITION;
	float3 normal : NORMAL;
	float2 uv : TEXCOORD0;
};

struct Interpolators {
	float4 position : SV_POSITION;
	float2 uv : TEXCOORD0;
	float3 normal : TEXCOORD1;
	float3 worldPos : TEXCOORD2;
#if defined(VERTEXLIGHT_ON)
	float3 vertexLightColor : TEXCOORD3
#endif
};

void ComputeVertexLightColor(inout Interpolators i) {
#if defined(VERTEXLIGHT_ON)
	float3 lightPos = float3(unity_4LightPosX0.x, unity_4LightPosX0.y, unity_4LightPosX0.z);
	float3 lightVec = lightPos - i.worldPos;
	float3 lightDir = normalize(lightVec);
	float ndot1 = DotClamped(i.normal, lightDir);
	float attenuation = 1 / (1 + dot(lightVec, lightVec) * unity_4LightAtten0.x);
	i.vertexLightColor = unity_LightColor[0].rgb * ndot1 * attenuation;
#endif
}

Interpolators MyVertexProgram (VertexData v) {
	Interpolators i;
	i.position = UnityObjectToClipPos(v.position);
	i.worldPos = mul(unity_ObjectToWorld, v.position);
	i.normal = UnityObjectToWorldNormal(v.normal);
	i.uv = TRANSFORM_TEX(v.uv, _MainTex);
	ComputeVertexLightColor(i);
	return i;
}

UnityLight CreateLight(Interpolators i) {
    UnityLight light;
#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
    light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
#else
	light.dir = _WorldSpaceLightPos0.xyz;
#endif
	float3 lightVec = _WorldSpaceLightPos0.xyz - i.worldPos;
    UNITY_lIGHT_ATTENUATION(attenuation, 0, i.worldPos);
    light.color = LightColor0.rgb;
    light.ndot1 = DotClamped(i.normal, light.dir);
    return light;
}

UnityIndirect CreateIndirectLight(Interpolators i) {
	UnityIndirect indirectLight;
	indirectLight.diffuse = 0;
	indirectLight.specular = 0;
#if defined(VERTEXLIGHT_ON)
	indirectLight.diffuse = i.vertexLightColor;
#endif
	return indirectLight;
}

float4 MyFragmentProgram (Interpolators i) : SV_TARGET {
	i.normal = normalize(i.normal);
	float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

	float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;

	float3 specularTint;
	float oneMinusReflectivity;
	albedo = DiffuseAndSpecularFromMetallic(albedo, _Metallic, specularTint, oneMinusReflectivity);

	return UNITY_BRDF_PBS(albedo, specularTint,oneMinusReflectivity, _Smoothness,i.normal, viewDir,CreateLight(i), CreateIndirectLight(i));
}

#endif