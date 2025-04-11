//-----------------------------------
// -- -juvs
//-----------------------------------
//
//-----------------------------------
// Global variables
//-----------------------------------
float4x4 g_matWorld; 
float4x4 g_matWV; 
float4x4 g_matWVP; 
float2   g_vFOG; 
float    g_fVS_1_1_ColorMulti = 0.75f; 
float    g_fAlpha; 
int      g_Flag; 
float2	 g_vLightMapUV_Offset; 
float    g_fTime; 
float3   g_vCameraFrom;
float4   g_vWindowSize;
float4  g_vDLightDir;

//material blend
float    g_fRotate_UV;	 
float    g_fScaleFactor; 

//material watercube
float2	 g_vReflectPower; 
float 	 g_fWaveDensity; 
float 	 g_fWaveScale; 
float 	 g_fWaveSpeed; 
float2   g_vMoveSpeed; 

//material texupdown
float    g_fTexColorUpDown = 1.f; 
float    g_fTexColorUpDownMin = 0.f; 
float    g_fTexColorUpDownAdd = 1.f; 
float	 g_fTexColorUpDownSpeed = 5.f; 

//material waterstream	
float 	 g_fImageScale0; 
float 	 g_fImageScale1; 
float2   g_vMoveSpeed0; 
float2   g_vMoveSpeed1; 

//material waterstream2 
float    g_fColorPower0;
float    g_fColorPower1;

//decal
float    g_fSpecularPower = 256.f; 
float    g_fSpecularIntensity = 0.f; 
float3	 g_vDecalBelndColor;  
float	 g_fCubeMapValue;
float	 g_fDecalNormal=1.f;
float	g_fSeamless_Near_Distance;
float	g_fSeamless_Far_Distance;
float	g_fSeamless_Far_Alpha;
float	g_fSeamless_Near_Alpha;
//
//-----------------------------------
// Material Parameters
//-----------------------------------
texture g_BaseTexture; 
sampler BaseTexSampler = sampler_state  
{ 
	Texture = (g_BaseTexture); 
}; 

texture g_BaseTexture2; 
sampler BaseTex2Sampler = sampler_state  
{ 
	Texture = (g_BaseTexture2); 
}; 

texture g_LightMapDayTex; 
sampler LightMapTexSampler_1st = sampler_state  
{ 
	Texture = (g_LightMapDayTex);	 
}; 

texture g_NormalTexture; 
sampler NormalTexSampler = sampler_state  
{ 
	Texture = (g_NormalTexture); 
}; 

texture g_ReflectTexRT; 
sampler ReflectTexRTSampler = sampler_state  
{ 
	Texture = (g_ReflectTexRT); 

	//AddressU = Mirror; 
	//AddressV = Mirror; 
}; 

texture g_CubeTexture; 
samplerCUBE CubeTexSampler = sampler_state  
{ 
	Texture = (g_CubeTexture); 
}; 
//
//-----------------------------------
// Basic vertex transformation 
//-----------------------------------
struct VS_INPUT	 
{ 
	float4 m_vPosition   : POSITION0; 
	float4 m_vVertColor  : COLOR0; 
	float3 m_vNormal     : NORMAL; 
	float2 m_vTexCoord0  : TEXCOORD0;  
}; 
 
struct VS_OUTPUT	 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float  m_fFog        : FOG; 
}; 
// 
//----------------------------------- 
// Shader 
//----------------------------------- 
VS_OUTPUT VS_1( VS_INPUT In )  
{ 
	VS_OUTPUT Out; 
 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vVertColor = In.m_vVertColor; 
	Out.m_vVertColor.xyz *= g_fVS_1_1_ColorMulti; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_1( VS_OUTPUT In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	vColor.xyz *= In.m_vVertColor.xyz; 
	vColor.w *= In.m_vVertColor.w;
	
	return vColor; 
} 
// 
//----------------------------------- 
//	technique  
//----------------------------------- 
technique runtime_1
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_1();  
		PixelShader = compile ps_2_0 PS_1();  
	}  
}  
//
//
