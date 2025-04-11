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
	float2 m_vLightmapUV : TEXCOORD1;  
}; 
 
struct VS_OUTPUT	 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float2 m_vLightmapUV : TEXCOORD1;  
	float  m_fFog        : FOG; 
}; 
 
struct VS_INPUT_BLEND	 
{ 
	float4 m_vPosition   : POSITION0; 
	float4 m_vVertColor  : COLOR0; 
	float3 m_vNormal     : NORMAL; 
	float2 m_vTexCoord0  : TEXCOORD0;  
}; 
 
struct VS_OUTPUT_BLEND	 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float  m_fFog        : FOG; 
}; 

struct VS_INPUT_LMLB	 
{ 
	float4 m_vPosition   : POSITION0; 
	float4 m_vVertColor  : COLOR0; 
	float3 m_vNormal     : NORMAL; 
	float2 m_vTexCoord0  : TEXCOORD0; 
	float2 m_vLightmapUV : TEXCOORD1; 
}; 
 
struct VS_OUTPUT_LMLB	 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float2 m_vTexCoord1 : TEXCOORD1; 
	float2 m_vLightmapUV  : TEXCOORD2; 
	float  m_fFog         : FOG; 
}; 

struct VS_INPUT_WC		 
{ 
	float4 m_vPosition  : POSITION;     
	float4 m_vVertColor : COLOR0; 
	float3 m_vNormal    : NORMAL; 
	float2 m_vTexCoord0 : TEXCOORD0; 
}; 
 
struct VS_OUTPUT_1_WC		 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float  m_fFog       : FOG; 
}; 
 
struct VS_OUTPUT_2_WC 
{  
	float4 m_vPosition       : POSITION;  
	float4 m_vVertColor      : COLOR0; 
	float2 m_vTexCoord0      : TEXCOORD0; 
	float2 m_vTexCoord1      : TEXCOORD1; 
	float3 m_vEnumPosition   : TEXCOORD2;  
	float  m_fFog            : FOG;  
};  

struct VS_INPUT_TUD	 
{ 
	float4 m_vPosition  : POSITION;   
	float2 m_vTexCoord0 : TEXCOORD0; 
}; 
 
struct VS_OUTPUT_TUD		 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vColor	: COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float  m_fFog       : FOG; 
}; 

struct VS_INPUT_WS	 
{ 
	float4 m_vPosition  : POSITION;     
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
}; 
 
struct VS_OUTPUT_WS		 
{ 
	float4 m_vPosition  : POSITION; 
	float4 m_vVertColor : COLOR0; 
	float2 m_vTexCoord0 : TEXCOORD0; 
	float2 m_vTexCoord1 : TEXCOORD1; 
	float  m_fFog       : FOG; 
}; 

struct VS_INPUT_TX	 
{ 
	float4 m_vPosition  : POSITION;    
	float2 m_vTexCoord0 : TEXCOORD0; 
}; 
 
struct VS_OUTPUT_TX		 
{ 
	float4 m_vPosition  : POSITION; 
	float2 m_vTexCoord0 : TEXCOORD0; 
}; 

//----------------------------------- 
// Helper
//----------------------------------- 
float2 rotateUVs(float2 Texcoords, float2 center, float theta) 
{  
	float2 sc;  
	sincos( theta, sc.x, sc.y );  
	float2 uv = Texcoords - center;  
	float2 rotateduv;  
	rotateduv.x = dot( uv, float2( sc.y, -sc.x ) );  
	rotateduv.y = dot( uv, sc.xy );	  
	rotateduv += center;  
	return rotateduv;  
}  

// 
//----------------------------------- 
// Shader 
//----------------------------------- 
VS_OUTPUT VS_LIGHTMAP( VS_INPUT In )  
{ 
	VS_OUTPUT Out; 
 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vLightmapUV = In.m_vLightmapUV; 
	Out.m_vLightmapUV.xy += g_vLightMapUV_Offset; 
 
	Out.m_vVertColor = In.m_vVertColor; 
	Out.m_vVertColor.xyz *= g_fVS_1_1_ColorMulti; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_LIGHTMAP( VS_OUTPUT In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	float4 vLightColor = tex2D( LightMapTexSampler_1st, In.m_vLightmapUV ); 
 
	vColor.xyz *= vLightColor.xyz * In.m_vVertColor.xyz * 4.f; 
 
	return vColor; 
} 
 
VS_OUTPUT VS_NOLIGHTMAP( VS_INPUT In )  
{ 
	VS_OUTPUT Out; 
 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vLightmapUV = In.m_vLightmapUV; 
	Out.m_vLightmapUV.xy += g_vLightMapUV_Offset;  
 
	Out.m_vVertColor = In.m_vVertColor; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 

VS_OUTPUT_BLEND VS_BLEND( VS_INPUT_BLEND In )  
{ 
	VS_OUTPUT_BLEND Out; 
 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vVertColor = In.m_vVertColor; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_NOLIGHTMAP( VS_OUTPUT In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	vColor.xyz *= In.m_vVertColor.xyz; 
 
	return vColor; 
} 

float4 PS_LIGHTMAP_ALPHA( VS_OUTPUT In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	float4 vLightColor = tex2D( LightMapTexSampler_1st, In.m_vLightmapUV ); 
 
	vColor.xyz *= vLightColor.xyz * In.m_vVertColor.xyz * 4.f; 
	vColor.w *= In.m_vVertColor.w;
 
	return vColor; 
} 

float4 PS_NOLIGHTMAP_ALPHA( VS_OUTPUT In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	vColor.xyz *= In.m_vVertColor.xyz; 
	vColor.w *= In.m_vVertColor.w;
 
	return vColor; 
} 

float4 PS_BLEND( VS_OUTPUT_BLEND In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	vColor.xyz *= In.m_vVertColor.xyz; 
	vColor.w *= In.m_vVertColor.w;
 
	return vColor; 
} 

VS_OUTPUT_LMLB VS_LMLB( VS_INPUT_LMLB In )  
{ 
	VS_OUTPUT_LMLB Out; 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
 
	float2 UVRotator_center = float2(0.0, 0.0); 
	float UVRotAngle = radians(g_fRotate_UV); 
	float2 UVRotator = rotateUVs(In.m_vTexCoord0, UVRotator_center, UVRotAngle);  
	Out.m_vTexCoord1 = (g_fScaleFactor * UVRotator).xy; 
 
	Out.m_vLightmapUV = In.m_vLightmapUV; 
	Out.m_vLightmapUV.xy += g_vLightMapUV_Offset; 
 
	Out.m_vVertColor = In.m_vVertColor; 
	Out.m_vVertColor.xyz *= g_fVS_1_1_ColorMulti; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_LMLB( VS_OUTPUT_LMLB In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	float4 vColor2 = tex2D(BaseTex2Sampler, In.m_vTexCoord1 ); 
	vColor = lerp(vColor2, vColor, In.m_vVertColor.w); 
 
	float4 vLightColor = tex2D( LightMapTexSampler_1st, In.m_vLightmapUV ); 
 
	vColor.xyz *= vLightColor.xyz * In.m_vVertColor.xyz * 4.f; 
	vColor.w = g_fAlpha; 
 
	return vColor; 
} 

VS_OUTPUT_1_WC VS_1_WC( VS_INPUT_WC In )  
{ 
	VS_OUTPUT_1_WC Out; 
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vVertColor = In.m_vVertColor; 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_1_WC( VS_OUTPUT_1_WC In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	vColor *= In.m_vVertColor; 
	vColor *= g_vReflectPower.xxxy; 
 
	return vColor; 
} 
 
VS_OUTPUT_2_WC VS_2_WC( VS_INPUT_WC In, uniform bool bReflectRT  )  
{ 
	VS_OUTPUT_2_WC Out; 
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP ); 
 
	Out.m_vTexCoord0 = In.m_vTexCoord0*g_fWaveDensity + float2(sin(g_fTime*g_fWaveSpeed), cos(g_fTime*g_fWaveSpeed)); 
	Out.m_vTexCoord1 = In.m_vTexCoord0*g_fWaveDensity + float2(sin(g_fTime*g_fWaveSpeed+(3.14f*0.5f)), cos(g_fTime*g_fWaveSpeed+(3.14f*0.5f))); 
	Out.m_vTexCoord0 += float2(g_fTime*g_vMoveSpeed.x, g_fTime*g_vMoveSpeed.y); 
	Out.m_vTexCoord1 += float2(g_fTime*g_vMoveSpeed.x, g_fTime*g_vMoveSpeed.y); 
	Out.m_vVertColor = In.m_vVertColor; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	Out.m_vEnumPosition.xyz = 1.f; 
	if ( bReflectRT ) 
	{ 
		Out.m_vEnumPosition.xyz = mul(In.m_vPosition, g_matWVP ).xyw; 
	} 
	else 
	{ 
		float3 vWorldPos = mul(In.m_vPosition, g_matWorld ); 
		Out.m_vEnumPosition = vWorldPos; 
	} 
 
	return Out; 
} 
 
float4 PS_2_WC( VS_OUTPUT_2_WC In ) : COLOR0  
{ 
	float3 vBump1 = tex2D( NormalTexSampler, In.m_vTexCoord0 ); 
	float3 vBump2 = tex2D( NormalTexSampler, In.m_vTexCoord1 ); 
 
	vBump1 = (vBump1.rgb * 2.0f) - 1.0f; 
	vBump2 = (vBump2.rgb * 2.0f) - 1.0f; 
	float3 vBump = normalize(vBump1 + vBump2); 
	vBump *= float3(g_fWaveScale,g_fWaveScale,1.f); 
	vBump = normalize(vBump); 
 
	float3 vEyeToVector = normalize(In.m_vEnumPosition - g_vCameraFrom); 
	float3 vCubeTexcoord = reflect(vEyeToVector, vBump.xzy); 
	float4 vColor = texCUBE( CubeTexSampler, vCubeTexcoord ); 
 
	vColor *= In.m_vVertColor; 
	vColor *= g_vReflectPower.xxxy; 
 
	return vColor; 
} 
 
float4 PS_2_WC_REAL_TIME( VS_OUTPUT_2_WC In ) : COLOR0  
{ 
	float3 vBump1 = tex2D( NormalTexSampler, In.m_vTexCoord0 ); 
	float3 vBump2 = tex2D( NormalTexSampler, In.m_vTexCoord1 ); 
 
	vBump1 = (vBump1.rgb * 2.0f) - 1.0f; 
	vBump2 = (vBump2.rgb * 2.0f) - 1.0f; 
	float3 vBump = normalize(vBump1 + vBump2); 
	vBump *= float3(g_fWaveScale,g_fWaveScale,1.f); 
	vBump = normalize(vBump); 
 
	float2 vProjectionUV = 0.5 * In.m_vEnumPosition.xy / In.m_vEnumPosition.z + float2( 0.5, 0.5 ); 
	vProjectionUV.y = 1.0f - vProjectionUV.y; 
	vProjectionUV.xy += g_vWindowSize.xy; 
	vProjectionUV.xy += vBump.xz; 
 
	float4 vColor = tex2D( ReflectTexRTSampler, vProjectionUV ); 
 
	vColor *= In.m_vVertColor; 
	vColor *= g_vReflectPower.xxxy; 
	//vColor.w = 1.0f; 
 
	return vColor; 
} 

VS_OUTPUT_TUD VS_TUD( VS_INPUT_TUD In )  
{ 
	VS_OUTPUT_TUD Out; 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
	Out.m_vColor = (g_fTexColorUpDownMin + (((sin(g_fTime*g_fTexColorUpDownSpeed)+1)*0.25f) * g_fTexColorUpDownAdd)); 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_TUD( VS_OUTPUT_TUD In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ) * In.m_vColor * 2.f; 
	return vColor; 
} 

VS_OUTPUT_WS VS_WS( VS_INPUT_WS In )  
{ 
	VS_OUTPUT_WS Out; 
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP ); 
 
	Out.m_vTexCoord0 = (In.m_vTexCoord0 * g_fImageScale0); 
	Out.m_vTexCoord1 = (In.m_vTexCoord0 * g_fImageScale1); 
	Out.m_vTexCoord0 += float2(g_fTime*g_vMoveSpeed0.x, g_fTime*g_vMoveSpeed0.y); 
	Out.m_vTexCoord1 += float2(g_fTime*g_vMoveSpeed1.x, g_fTime*g_vMoveSpeed1.y); 
 
	Out.m_vVertColor = In.m_vVertColor; 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_WS( VS_OUTPUT_WS In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	float4 vColor2 = tex2D( BaseTex2Sampler, In.m_vTexCoord1 ); 
	vColor += vColor2; 
 
	vColor.w = g_fAlpha; 
 
	return vColor; 
} 

VS_OUTPUT_WS VS_WS_ADD( VS_INPUT_WS In )  
{ 
	VS_OUTPUT_WS Out; 
	Out.m_vPosition = mul(In.m_vPosition, g_matWVP); 
 
	Out.m_vTexCoord0 = (In.m_vTexCoord0 * g_fImageScale0); 
	Out.m_vTexCoord1 = (In.m_vTexCoord0 * g_fImageScale1); 
	Out.m_vTexCoord0 += float2(g_fTime*g_vMoveSpeed0.x, g_fTime*g_vMoveSpeed0.y); 
	Out.m_vTexCoord1 += float2(g_fTime*g_vMoveSpeed1.x, g_fTime*g_vMoveSpeed1.y); 
 
	Out.m_vVertColor = In.m_vVertColor; 
 
	Out.m_fFog = saturate((g_vFOG.x - Out.m_vPosition.z) / g_vFOG.y); 
 
	return Out; 
} 
 
float4 PS_WS_ADD( VS_OUTPUT_WS In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ) * g_fColorPower0; 
	float4 vColor2 = tex2D( BaseTex2Sampler, In.m_vTexCoord1 ) * g_fColorPower1; 
	vColor += vColor2; 
 
	vColor.xyz *= In.m_vVertColor.a * g_fAlpha; 
 
	return vColor; 
}

VS_OUTPUT_TX VS_TX( VS_INPUT_TX In )  
{ 
	VS_OUTPUT_TX Out; 
	Out.m_vPosition = mul( In.m_vPosition, g_matWVP ); 
	Out.m_vTexCoord0 = In.m_vTexCoord0; 
 
	return Out; 
} 
 
float4 PS_TX( VS_OUTPUT_TX In ) : COLOR0  
{ 
	float4 vColor = tex2D( BaseTexSampler, In.m_vTexCoord0 ); 
	return vColor; 
} 
// 
//----------------------------------- 
//	technique  
//----------------------------------- 
technique runtime_lightmap  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_LIGHTMAP();  
		PixelShader = compile ps_2_0 PS_LIGHTMAP();  
	}  
}  
 
technique runtime_nolightmap  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_NOLIGHTMAP();  
		PixelShader = compile ps_2_0 PS_NOLIGHTMAP();  
	}  
}  

technique runtime_alpha_lightmap 
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_LIGHTMAP();  
		PixelShader = compile ps_2_0 PS_LIGHTMAP_ALPHA();  
	}   
} 

technique runtime_alpha_nolightmap 
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_LIGHTMAP();  
		PixelShader = compile ps_2_0 PS_NOLIGHTMAP_ALPHA();  
	}   
} 

technique runtime_blend
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_BLEND();  
		PixelShader = compile ps_2_0 PS_BLEND();  
	}   
} 

technique runtime_lmlb
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_LMLB();  
		PixelShader = compile ps_2_0 PS_LMLB();  
	}   
}

technique runtime_lmlb2
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_LMLB();  
		PixelShader = compile ps_2_0 PS_LMLB();  
	}   
}

technique runtime_wc  
{  
	//pass high1  
	//{  
	//	VertexShader = compile vs_2_0 VS_1_WC();  
	//	PixelShader = compile ps_2_0 PS_1_WC();  
	//
	//	FOGENABLE = FALSE; 
	//	ALPHABLENDENABLE = TRUE; 
	//	SRCBLEND = SRCALPHA; 
	//	DESTBLEND = INVSRCALPHA; 
	//	FOGCOLOR = 0L; 
	//}  
	
	pass high2 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(false);  
		PixelShader = compile ps_2_0 PS_2_WC();  
 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
	} 
 
	pass realtime 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(true);  
		PixelShader = compile ps_2_0 PS_2_WC_REAL_TIME();  
 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
	} 
}; 

technique runtime_wc2  
{  
	//pass high1  
	//{  
	//	VertexShader = compile vs_2_0 VS_1_WC();  
	//	PixelShader = compile ps_2_0 PS_1_WC();  
	//
	//	DEPTHBIAS = -0.00020f; 
	//	FOGENABLE = FALSE; 
	//	ALPHABLENDENABLE = TRUE; 
	//	SRCBLEND = SRCALPHA; 
	//	DESTBLEND = INVSRCALPHA; 
	//	FOGCOLOR = 0L; 
	//}  
	
	pass high2 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(false);  
		PixelShader = compile ps_2_0 PS_2_WC();  
 
		DEPTHBIAS = -0.00020f; 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
	} 
 
	pass realtime 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(true);  
		PixelShader = compile ps_2_0 PS_2_WC_REAL_TIME();  
 
		DEPTHBIAS = -0.00020f; 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
	} 
}; 

technique runtime_gc  
{  
	//pass high1  
	//{  
	//	VertexShader = compile vs_2_0 VS_1_WC();  
	//	PixelShader = compile ps_2_0 PS_1_WC();  
	//
	//	//DEPTHBIAS = -0.0001f; 
	//	FOGENABLE = FALSE; 
	//	ALPHABLENDENABLE = TRUE; 
	//	SRCBLEND = SRCALPHA; 
	//	DESTBLEND = INVSRCALPHA; 
	//	FOGCOLOR = 0L; 
	//	ZWRITEENABLE = FALSE; 
	//}  
	
	pass high2 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(false);  
		PixelShader = compile ps_2_0 PS_2_WC();  
 
		DEPTHBIAS = -0.0001f; 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
		ZWRITEENABLE = FALSE; 
	} 
 
	pass realtime 
	{  
		VertexShader = compile vs_2_0 VS_2_WC(true);  
		PixelShader = compile ps_2_0 PS_2_WC_REAL_TIME();  
 
		DEPTHBIAS = -0.0001f; 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
		FOGCOLOR = 0L; 
		ZWRITEENABLE = FALSE; 
	} 
};

technique runtime_tud  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_TUD();  
		PixelShader = compile ps_2_0 PS_TUD(); 
 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = SRCALPHA; 
		DESTBLEND = INVSRCALPHA; 
        FOGCOLOR = 0L;
	}  
}  

technique runtime_ws  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_WS();  
		PixelShader = compile ps_2_0 PS_WS();  
	}  
}  

technique runtime_ws_add  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_WS_ADD();  
		PixelShader = compile ps_2_0 PS_WS_ADD();  
 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = ONE; 
		DESTBLEND = ONE; 
		//FOGCOLOR = 0L; 
	}  
}  

technique runtime_tx  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_TX();  
		PixelShader = compile ps_2_0 PS_TX(); 
		FOGENABLE = FALSE; 
	}  
};

technique runtime_tx_add  
{  
	pass high  
	{  
		VertexShader = compile vs_2_0 VS_TX();  
		PixelShader = compile ps_2_0 PS_TX(); 
		FOGENABLE = FALSE; 
		ALPHABLENDENABLE = TRUE; 
		SRCBLEND = ONE; 
		DESTBLEND = ONE; 
	}  
}; 

