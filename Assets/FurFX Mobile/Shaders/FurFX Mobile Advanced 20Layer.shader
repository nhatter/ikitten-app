Shader "FurFX/Mobile/FurFX Advanced 20 Layer"
{
	Properties
	{
		_Color ("Color (RGB)", Color) = (1,1,1,1)
	  	_SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  	_RimColor ("Rim Color", Color) = (0.0,0.0,0.0,0.0)
      	_RimPower ("Rim Power", Range(0.5,8.0)) = 4.0
	  	_Shininess ("Shininess", Range (0.01, 10)) = 8		
		_FurLength ("Fur Length", Range (.0002, 0.5)) = .05
		_MainTex ("Base (RGB) Mask(A)", 2D) = "white" { }
		_NoiseTex ("Noise (RGB)", 2D) = "white" { }
		_Cube ("Reflection Map", Cube) = "" {}
		_Reflection("Reflection Power", Range (0.00, 1)) = 0.0
		_Cutoff ("Alpha Cutoff", Range (0, 1)) = .0001
		_EdgeFade ("Edge Fade", Range(0,1)) = 0.15
		_HairHardness ("Fur Hardness", Range(0.1,1)) = 1
		_HairThinness ("Fur Thinness", Range(0.01,10)) = 2
		_HairShading ("Fur Shading", Range(0.0,1)) = 0.25
		_SkinAlpha ("Mask Alpha Factor", Range(0.0,1)) = 0.5
		_ForceGlobal ("Force Global",Vector) = (0,0,0,0)		
		_ForceLocal ("Force Local",Vector) = (0,0,0,0)	
	}
	Category
	{
		ZWrite On
		Tags {"Queue" = "Transparent"}
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
		
		SubShader
		{
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 62 to 62
//   d3d9 - ALU: 71 to 71
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"!!ARBvp1.0
# 62 ALU
PARAM c[35] = { { 0, 1, 2 },
		state.lightmodel.ambient,
		program.local[2..5],
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..34] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, c[11];
DP3 R2.w, R1, R2;
MUL R3.xyz, R1, c[0].z;
MAD R2.xyz, -R3, -R2.w, -R2;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R0.w, R1.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R2, R0;
MAX R0.w, R0, c[0].x;
POW R3.x, R0.w, c[29].x;
SLT R0.w, R2, c[0].x;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[32];
MUL R4.xyz, R2, R3.x;
ABS R0.w, R0;
MOV R2.xyz, c[27];
MOV R3.xyz, c[27];
DP3 R1.w, R1, R0;
SGE R0.w, c[0].x, R0;
MAX R2.w, R2, c[0].x;
MUL R2.xyz, R2, c[32];
MUL R2.xyz, R2, R2.w;
MUL R3.xyz, R3, c[1];
ADD R2.xyz, R3, R2;
MAD result.color.xyz, R4, R0.w, R2;
MIN R2.x, R1.w, c[0].y;
MAX R2.x, R2, c[0];
MOV R0.w, c[0].x;
MOV R1.w, c[0].x;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[0].z, -R0;
ADD R2.x, -R2, c[0].y;
POW R0.y, R2.x, c[31].x;
MOV R0.x, c[12];
MOV R0.w, c[0].y;
MUL result.texcoord[2].xyz, R0.y, c[30];
MUL R0.x, R0, c[0];
ADD R0.xyz, vertex.position, R0.x;
DP4 result.position.w, R0, c[9];
DP4 result.position.z, R0, c[8];
DP4 result.position.y, R0, c[7];
DP4 result.position.x, R0, c[6];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[34].xyxy, c[34];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[33], c[33].zwzw;
DP4 result.texcoord[1].y, vertex.texcoord[0], c[22];
DP4 result.texcoord[1].x, vertex.texcoord[0], c[21];
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 62 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_Color]
Vector 25 [_SpecColor]
Float 26 [_Shininess]
Vector 27 [_RimColor]
Float 28 [_RimPower]
Vector 29 [_LightColor0]
Vector 30 [_MainTex_ST]
Vector 31 [_NoiseTex_ST]
"vs_2_0
; 71 ALU
def c32, 0.00000000, 1.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c32.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
dp3 r0.x, c22, c22
mul r3.xyz, r2, c32.z
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r1.xyz, -r1, c21
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp3 r0.y, r2, r1
min r0.w, r0.y, c32.y
rsq r0.x, r0.x
mul r0.xyz, r0.x, c22
dp3 r3.w, r2, r0
mad r0.xyz, -r3.w, -r3, -r0
dp3 r0.y, r0, r1
max r1.w, r0, c32.x
max r3.x, r0.y, c32
slt r0.x, r3.w, c32
sge r0.y, c32.x, r0.x
sge r0.x, r0, c32
mul r2.w, r0.x, r0.y
pow r0, r3.x, c26.x
max r0.y, -r2.w, r2.w
slt r0.w, c32.x, r0.y
mov r2.w, r0.x
mov r0.xyz, c29
max r3.x, r3.w, c32
mul r0.xyz, c24, r0
mul r4.xyz, r0, r3.x
mov r3.xyz, c20
mov r0.xyz, c29
mul r3.xyz, c24, r3
mul r0.xyz, c25, r0
mul r0.xyz, r0, r2.w
add r3.xyz, r3, r4
mad oD0.xyz, r0.w, r0, r3
add r3.x, -r1.w, c32.y
pow r0, r3.x, c28.x
mov r0.y, r0.x
mov r0.x, c32
mov r0.w, c32.y
mov r1.w, c32.x
mov r2.w, c32.x
dp4 r3.y, r2, -r1
mul r2, r2, r3.y
mul oT2.xyz, r0.y, c27
mul r0.x, c23, r0
add r0.xyz, v0, r0.x
mad oT3, -r2, c32.z, -r1
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mad oT0.zw, v2.xyxy, c31.xyxy, c31
mad oT0.xy, v2, c30, c30.zwzw
dp4 oT1.y, v2, c9
dp4 oT1.x, v2, c8
mov oD0.w, c32.y
mov oT2.w, c32.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;



uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_4;
  tmpvar_4 = _glesVertex.xyz;
  P = tmpvar_4;
  highp vec3 tmpvar_5;
  tmpvar_5 = P;
  P = tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = P;
  highp vec4 tmpvar_7;
  tmpvar_7 = (gl_ModelViewProjectionMatrix * tmpvar_6);
  highp vec2 tmpvar_8;
  tmpvar_8 = (gl_TextureMatrix1 * _glesMultiTexCoord0).xy;
  tmpvar_2.xy = tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * _World2Object).xyz);
  normalDirection = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_12;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_15;
  tmpvar_15 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_14));
  highp vec3 tmpvar_16;
  tmpvar_16 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_16;
  if ((tmpvar_14 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_17;
    tmpvar_17 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_18;
    tmpvar_18 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_17, _Shininess));
    specularReflection = tmpvar_18;
  };
  mediump vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = viewDirection;
  lowp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = normalDirection;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = ((ambientLighting + tmpvar_15) + specularReflection);
  gl_Position = tmpvar_7;
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_COLOR0 = tmpvar_22;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = reflect (-(tmpvar_20), tmpvar_21);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform sampler2D _MainTex;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  o.xyz = (tmpvar_1.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.w = 1.0;
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 4 to 4, TEX: 1 to 1
//   d3d9 - ALU: 4 to 4, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 4 ALU, 1 TEX
PARAM c[1] = { { 1, 2 } };
TEMP R0;
TEX R0.xyz, fragment.texcoord[0], texture[0], 2D;
MUL R0.xyz, fragment.color.primary, R0;
MUL result.color.xyz, R0, c[0].y;
MOV result.color.w, c[0].x;
END
# 4 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 4 ALU, 1 TEX
dcl_2d s0
def c0, 2.00000000, 1.00000000, 0, 0
dcl t0.xy
dcl v0.xyz
texld r0, t0, s0
mul_pp r0.xyz, v0, r0
mul_pp r0.xyz, r0, c0.x
mov_pp r0.w, c0.y
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 42

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.049987793, 1, -1, 0.0025000002 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 5.4965902e-005, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.04998779, 1.00000000, -1.00000000, 0.00250000
def c36, 0.00005497, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.05) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0025) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (5.5e-005 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.05 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.814506 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.81445313, 2, 0.0025005341, 0.049987793 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.04998779, 1.00000000, 0.00000000, 0.81445313
def c6, 0.00250053, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 54

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.099975586, 1, -1, 0.010000001 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.0001099318, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.09997559, 1.00000000, -1.00000000, 0.01000000
def c36, 0.00010993, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.1) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.01) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00011 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.1 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.6561 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.01 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.65625, 2, 0.010002136, 0.099975586 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.09997559, 1.00000000, 0.00000000, 0.65625000
def c6, 0.01000214, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 66

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.15002441, 1, -1, 0.022500001 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00016496482, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.15002441, 1.00000000, -1.00000000, 0.02250000
def c36, 0.00016496, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.15) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0225) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000165 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.15 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.522006 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.52197266, 2, 0.022506714, 0.15002441 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.15002441, 1.00000000, 0.00000000, 0.52197266
def c6, 0.02250671, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 78

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.19995117, 1, -1, 0.040000003 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00021986361, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.19995117, 1.00000000, -1.00000000, 0.04000000
def c36, 0.00021986, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.2) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.04) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00022 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.2 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.4096 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.04 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.40966797, 2, 0.040008545, 0.19995117 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.19995117, 1.00000000, 0.00000000, 0.40966797
def c6, 0.04000854, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 90

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.25, 1, -1, 0.0625 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00027489662, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.25000000, 1.00000000, -1.00000000, 0.06250000
def c36, 0.00027490, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.25) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.0625) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000275 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.25 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.316406 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.0625 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.31640625, 2, 0.0625, 0.25 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.25000000, 1.00000000, 0.00000000, 0.31640625
def c6, 0.06250000, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 102

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.30004883, 1, -1, 0.090000004 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00032992964, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.30004883, 1.00000000, -1.00000000, 0.09000000
def c36, 0.00032993, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.3) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.09) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00033 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.3 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.2401 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.09 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.2401123, 2, 0.090026855, 0.30004883 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.30004883, 1.00000000, 0.00000000, 0.24011230
def c6, 0.09002686, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 114

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.35009766, 1, -1, 0.12249999 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00038496265, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.35009766, 1.00000000, -1.00000000, 0.12249999
def c36, 0.00038496, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.35) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.1225) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000385 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.35 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.178506 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.1225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.1784668, 2, 0.12249756, 0.35009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.35009766, 1.00000000, 0.00000000, 0.17846680
def c6, 0.12249756, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 126

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.39990234, 1, -1, 0.16000001 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00043972721, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.39990234, 1.00000000, -1.00000000, 0.16000001
def c36, 0.00043973, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.4) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.16) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00044 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.4 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.1296 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.16 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.12963867, 2, 0.16003418, 0.39990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.39990234, 1.00000000, 0.00000000, 0.12963867
def c6, 0.16003418, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 138

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.44995117, 1, -1, 0.20249999 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00049476023, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.44995117, 1.00000000, -1.00000000, 0.20249999
def c36, 0.00049476, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.45) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.2025) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000495 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.45 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0915063 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.2025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.091491699, 2, 0.20251465, 0.44995117 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.44995117, 1.00000000, 0.00000000, 0.09149170
def c6, 0.20251465, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 150

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.5, 1, -1, 0.25 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00054979324, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.50000000, 1.00000000, -1.00000000, 0.25000000
def c36, 0.00054979, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.5) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.25) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00055 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.5 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.25 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.0625, 2, 0.25, 0.5 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.50000000, 1.00000000, 0.00000000, 0.06250000
def c6, 0.25000000, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 162

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.54980469, 1, -1, 0.30250001 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.0006045578, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.54980469, 1.00000000, -1.00000000, 0.30250001
def c36, 0.00060456, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.55) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.3025) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000605 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.55 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0410062 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.3025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.041015625, 2, 0.30249023, 0.54980469 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.54980469, 1.00000000, 0.00000000, 0.04101563
def c6, 0.30249023, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 174

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.60009766, 1, -1, 0.36000001 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00065985927, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.60009766, 1.00000000, -1.00000000, 0.36000001
def c36, 0.00065986, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.6) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.36) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00066 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.6 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0256 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.36 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.025604248, 2, 0.36010742, 0.60009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.60009766, 1.00000000, 0.00000000, 0.02560425
def c6, 0.36010742, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 186

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.64990234, 1, -1, 0.42249995 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00071462383, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.64990234, 1.00000000, -1.00000000, 0.42249995
def c36, 0.00071462, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.65) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.4225) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000715 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.65 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0150062 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.4225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.015007019, 2, 0.42260742, 0.64990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.64990234, 1.00000000, 0.00000000, 0.01500702
def c6, 0.42260742, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 198

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.70019531, 1, -1, 0.48999998 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.0007699253, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.70019531, 1.00000000, -1.00000000, 0.48999998
def c36, 0.00076993, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.7) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.49) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00077 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.7 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0081 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.49 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.008102417, 2, 0.48999023, 0.70019531 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.70019531, 1.00000000, 0.00000000, 0.00810242
def c6, 0.48999023, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 210

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.75, 1, -1, 0.5625 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00082468987, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.75000000, 1.00000000, -1.00000000, 0.56250000
def c36, 0.00082469, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.75) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.5625) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000825 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.75 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.00390625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.5625 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.00390625, 2, 0.5625, 0.75 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.75000000, 1.00000000, 0.00000000, 0.00390625
def c6, 0.56250000, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 222

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.79980469, 1, -1, 0.64000005 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00087945443, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.79980469, 1.00000000, -1.00000000, 0.64000005
def c36, 0.00087945, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.8) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.64) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00088 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.8 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0016 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.64 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.0016002655, 2, 0.64013672, 0.79980469 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.79980469, 1.00000000, 0.00000000, 0.00160027
def c6, 0.64013672, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 234

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.85009766, 1, -1, 0.72250003 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.0009347559, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.85009766, 1.00000000, -1.00000000, 0.72250003
def c36, 0.00093476, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.85) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.7225) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.000935 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.85 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.00050625 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.7225 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.00050640106, 2, 0.72265625, 0.85009766 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.85009766, 1.00000000, 0.00000000, 0.00050640
def c6, 0.72265625, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 246

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.89990234, 1, -1, 0.80999994 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.00098952046, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.89990234, 1.00000000, -1.00000000, 0.80999994
def c36, 0.00098952, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.9) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.81) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.00099 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.9 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0001 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.81 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 19 to 19, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[7] = { program.local[0..4],
		{ 0.00010001659, 2, 0.81005859, 0.89990234 },
		{ -1, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R1, fragment.texcoord[0], texture[0], 2D;
MOV R2.zw, c[5].xyxz;
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
MAX R0.x, R1.w, c[2];
ADD R0.x, -R0, c[5].w;
CMP R0.x, -R0, c[6], c[6].y;
SLT R0.x, R0, c[6].z;
MAD R1.xyz, R2.z, -c[3].x, R1;
TEX R3.x, R2, texture[1], 2D;
KIL -R0.x;
TEX R0.xyz, fragment.texcoord[3], texture[2], CUBE;
MAD_SAT R0.w, R2, -c[0].x, R3.x;
MOV R2.xyz, fragment.texcoord[2];
MUL R0.xyz, R0, c[4].x;
MUL R0.xyz, R0, R0.w;
MAD R1.xyz, fragment.color.primary, R1, R2;
MAD result.color.xyz, R1, c[5].y, R0;
MOV result.color.w, R0;
END
# 18 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
Float 4 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 19 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c5, 0.89990234, 1.00000000, 0.00000000, 0.00010002
def c6, 0.81005859, 2.00000000, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r2, t0, s0
max_pp r0.x, r2.w, c2
add_pp r0.x, -r0, c5
cmp r0.x, -r0, c5.y, -c5.y
cmp r0.x, r0, c5.z, c5.y
mov_pp r0, -r0.x
mov r1.y, t0.w
mov r1.x, t0.z
mul_pp r1.xy, r1, c1.x
mov_pp r3.xyz, t2
texld r4, r1, s1
texkill r0.xyzw
texld r1, t3, s2
mov_pp r0.x, c3
mad_pp r0.xyz, c5.w, -r0.x, r2
mad_pp r2.xyz, v0, r0, r3
mov_pp r0.x, c0
mad_pp_sat r0.x, c6, -r0, r4
mul_pp r1.xyz, r1, c4.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r2, c6.y, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 258

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 80 to 80
//   d3d9 - ALU: 90 to 90
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 10 [_WorldSpaceCameraPos]
Vector 11 [_WorldSpaceLightPos0]
Matrix 13 [_Object2World]
Matrix 17 [_World2Object]
Float 12 [_FurLength]
Vector 25 [_ForceGlobal]
Vector 26 [_ForceLocal]
Float 27 [_HairHardness]
Vector 28 [_Color]
Vector 29 [_SpecColor]
Float 30 [_Shininess]
Vector 31 [_RimColor]
Float 32 [_RimPower]
Vector 33 [_LightColor0]
Vector 34 [_MainTex_ST]
Vector 35 [_NoiseTex_ST]
"!!ARBvp1.0
# 80 ALU
PARAM c[37] = { { 0.95019531, 1, -1, 0.90249997 },
		state.lightmodel.ambient,
		state.matrix.projection,
		state.matrix.mvp,
		program.local[10..20],
		state.matrix.texture[1],
		program.local[25..35],
		{ 0.0010448219, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[18];
MAD R0.xyz, vertex.normal.x, c[17], R0;
MAD R0.xyz, vertex.normal.z, c[19], R0;
ADD R0.xyz, R0, c[36].y;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.w, c[11], c[11];
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, c[11];
DP3 R0.w, R1, -R3;
MUL R2.xyz, R1, c[36].z;
SLT R2.w, -R0, c[36].y;
MAD R2.xyz, -R2, R0.w, -R3;
MOV R4.xyz, c[28];
ABS R2.w, R2;
MAX R0.w, -R0, c[36].y;
DP4 R0.z, vertex.position, c[15];
DP4 R0.x, vertex.position, c[13];
DP4 R0.y, vertex.position, c[14];
ADD R0.xyz, -R0, c[10];
DP3 R1.w, R0, R0;
RSQ R1.w, R1.w;
MUL R0.xyz, R1.w, R0;
DP3 R1.w, R2, R0;
MAX R1.w, R1, c[36].y;
MOV R2.xyz, c[29];
POW R1.w, R1.w, c[30].x;
MUL R2.xyz, R2, c[33];
MUL R3.xyz, R2, R1.w;
MOV R2.xyz, c[28];
MUL R2.xyz, R2, c[33];
MUL R5.xyz, R2, R0.w;
MUL R4.xyz, R4, c[1];
ADD R4.xyz, R4, R5;
SGE R1.w, c[36].y, R2;
MAD result.color.xyz, R3, R1.w, R4;
MOV R0.w, c[0].y;
MIN R2, R0.w, c[25];
MAX R2, R2, c[0].z;
MIN R3, R0.w, c[26];
DP4 R4.z, R2, c[19];
DP4 R4.y, R2, c[18];
DP4 R4.x, R2, c[17];
MAX R3, R3, c[0].z;
MOV R2.w, c[0].y;
MOV R0.w, c[36].y;
DP4 R2.z, R3, c[4];
DP4 R2.y, R3, c[3];
DP4 R2.x, R3, c[2];
MUL R3.xyz, vertex.normal, c[12].x;
ADD R2.xyz, R4, R2;
MUL R3.xyz, R3, c[27].x;
MUL R2.xyz, R2, c[12].x;
MUL R3.xyz, R3, c[0].x;
MOV R1.w, c[36].y;
MUL R2.xyz, R2, c[0].w;
ADD R3.xyz, vertex.position, R3;
ADD R2.xyz, R3, R2;
DP4 result.position.w, R2, c[9];
DP4 result.position.z, R2, c[8];
DP4 result.position.y, R2, c[7];
DP4 result.position.x, R2, c[6];
DP3 R2.x, R1, R0;
DP4 R2.y, R1, -R0;
MUL R1, R1, R2.y;
MAD result.texcoord[3], -R1, c[36].z, -R0;
MIN R2.x, R2, c[0].y;
MAX R2.x, R2, c[36].y;
ADD R0.y, -R2.x, c[0];
POW R1.x, R0.y, c[32].x;
ADD R0.x, -vertex.normal.z, c[0].y;
MAD R0, R0.x, c[36].x, vertex.texcoord[0];
MUL result.texcoord[2].xyz, R1.x, c[31];
DP4 result.texcoord[1].y, R0, c[22];
DP4 result.texcoord[1].x, R0, c[21];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[35].xyxy, c[35];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[34], c[34].zwzw;
MOV result.color.w, c[0].y;
MOV result.texcoord[2].w, c[0].y;
END
# 80 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 20 [glstate_lightmodel_ambient]
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [glstate_matrix_texture1]
Vector 21 [_WorldSpaceCameraPos]
Vector 22 [_WorldSpaceLightPos0]
Matrix 12 [_Object2World]
Matrix 16 [_World2Object]
Float 23 [_FurLength]
Vector 24 [_ForceGlobal]
Vector 25 [_ForceLocal]
Float 26 [_HairHardness]
Vector 27 [_Color]
Vector 28 [_SpecColor]
Float 29 [_Shininess]
Vector 30 [_RimColor]
Float 31 [_RimPower]
Vector 32 [_LightColor0]
Vector 33 [_MainTex_ST]
Vector 34 [_NoiseTex_ST]
"vs_2_0
; 90 ALU
def c35, 0.95019531, 1.00000000, -1.00000000, 0.90249997
def c36, 0.00104482, 0.00000000, 2.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c17
mad r0.xyz, v1.x, c16, r0
mad r0.xyz, v1.z, c18, r0
add r0.xyz, r0, c36.y
dp3 r0.w, r0, r0
rsq r0.w, r0.w
dp3 r1.x, c22, c22
rsq r1.x, r1.x
mul r2.xyz, r1.x, c22
mul r0.xyz, r0.w, r0
mov r4.xyz, c20
dp3 r1.w, r0, r2
dp4 r1.z, v0, c14
dp4 r1.x, v0, c12
dp4 r1.y, v0, c13
add r3.xyz, -r1, c21
dp3 r0.w, r3, r3
mul r1.xyz, r0, c36.z
mad r2.xyz, -r1.w, -r1, -r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r3
dp3 r2.y, r2, r1
slt r0.w, r1, c36.y
sge r2.x, c36.y, r0.w
sge r0.w, r0, c36.y
mul r0.w, r0, r2.x
max r3.x, r2.y, c36.y
pow r2, r3.x, c29.x
max r0.w, -r0, r0
mov r2.w, r2.x
mov r3.xyz, c32
mul r2.xyz, c28, r3
mul r3.xyz, r2, r2.w
mov r2.xyz, c32
slt r0.w, c36.y, r0
max r1.w, r1, c36.y
mul r2.xyz, c27, r2
mul r5.xyz, r2, r1.w
mov r2, c24
mul r4.xyz, c27, r4
add r4.xyz, r4, r5
mad oD0.xyz, r0.w, r3, r4
dp3 r0.w, r0, r1
min r2, c35.y, r2
max r2, r2, c35.z
mov r3, c25
min r3, c35.y, r3
dp4 r4.z, r2, c18
dp4 r4.y, r2, c17
dp4 r4.x, r2, c16
max r3, r3, c35.z
mov r2.w, c35.y
dp4 r2.z, r3, c2
dp4 r2.y, r3, c1
dp4 r2.x, r3, c0
mul r3.xyz, v1, c23.x
add r2.xyz, r4, r2
mul r3.xyz, r3, c26.x
mul r2.xyz, r2, c23.x
mul r3.xyz, r3, c35.x
add r3.xyz, v0, r3
mul r2.xyz, r2, c35.w
add r2.xyz, r3, r2
dp4 oPos.w, r2, c7
dp4 oPos.z, r2, c6
dp4 oPos.y, r2, c5
dp4 oPos.x, r2, c4
min r0.w, r0, c35.y
max r2.x, r0.w, c36.y
mov r0.w, c36.y
mov r1.w, c36.y
dp4 r2.y, r0, -r1
add r3.x, -r2, c35.y
mul r2, r0, r2.y
pow r0, r3.x, c31.x
mad oT3, -r2, c36.z, -r1
mov r1.x, r0
add r0.y, -v1.z, c35
mad r0, r0.y, c36.x, v2
mul oT2.xyz, r1.x, c30
dp4 oT1.y, r0, c9
dp4 oT1.x, r0, c8
mad oT0.zw, v2.xyxy, c34.xyxy, c34
mad oT0.xy, v2, c33, c33.zwzw
mov oD0.w, c35.y
mov oT2.w, c35.y
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ProjectionMatrix glstate_matrix_projection
uniform mat4 glstate_matrix_projection;
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_TextureMatrix1 glstate_matrix_texture1
uniform mat4 glstate_matrix_texture1;
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD1;
varying mediump vec4 xlv_TEXCOORD0;




uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform mediump float _RimPower;
uniform lowp vec4 _RimColor;
uniform highp mat4 _Object2World;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _LightColor0;
uniform lowp float _HairHardness;
uniform lowp float _FurLength;
uniform highp vec4 _ForceLocal;
uniform highp vec4 _ForceGlobal;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 viewDirection;
  lowp vec3 lightDirection;
  lowp vec3 normalDirection;
  lowp vec3 posWorld;
  lowp vec3 P;
  mediump vec4 tmpvar_2;
  mediump vec4 tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_2.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_5;
  tmpvar_5 = (_glesVertex.xyz + (((tmpvar_1 * _FurLength) * 0.95) * _HairHardness));
  P = tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.9025) * _FurLength));
  P = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = P;
  highp vec4 tmpvar_8;
  tmpvar_8 = (gl_ModelViewProjectionMatrix * tmpvar_7);
  lowp vec4 tmpvar_9;
  tmpvar_9 = vec4((1.0 - dot (tmpvar_1, vec3(0.0, 0.0, 1.0))));
  highp vec2 tmpvar_10;
  tmpvar_10 = (gl_TextureMatrix1 * (_glesMultiTexCoord0 + (0.001045 * tmpvar_9))).xy;
  tmpvar_3.xy = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = (_Object2World * _glesVertex).xyz;
  posWorld = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_1;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((tmpvar_12 * _World2Object).xyz);
  normalDirection = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (_WorldSpaceLightPos0.xyz);
  lightDirection = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_WorldSpaceCameraPos - posWorld));
  viewDirection = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = dot (normalDirection, lightDirection);
  lowp vec3 tmpvar_17;
  tmpvar_17 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, tmpvar_16));
  highp vec3 tmpvar_18;
  tmpvar_18 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_18;
  if ((tmpvar_16 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_19;
    tmpvar_19 = max (0.0, dot (reflect (-(lightDirection), normalDirection), viewDirection));
    mediump vec3 tmpvar_20;
    tmpvar_20 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_19, _Shininess));
    specularReflection = tmpvar_20;
  };
  mediump vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = (_RimColor.xyz * pow ((1.0 - clamp (dot (viewDirection, normalDirection), 0.0, 1.0)), _RimPower));
  tmpvar_4 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = viewDirection;
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = normalDirection;
  lowp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((ambientLighting + tmpvar_17) + specularReflection);
  gl_Position = tmpvar_8;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_COLOR0 = tmpvar_24;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = reflect (-(tmpvar_22), tmpvar_23);
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec4 xlv_TEXCOORD2;
varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform lowp float _Reflection;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
uniform samplerCube _Cube;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((0.95 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = (tmpvar_1.xyz - (0.0 * _HairShading));
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - (0.9025 * _EdgeFade)), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (o.xyz * (xlv_COLOR0 * 2.0).xyz);
  o.xyz = (o.xyz + (xlv_TEXCOORD2 * 2.0).xyz);
  o.xyz = (o.xyz + ((textureCube (_Cube, xlv_TEXCOORD3.xyz).xyz * _Reflection) * o.w));
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 18 to 18, TEX: 3 to 3
//   d3d9 - ALU: 17 to 17, TEX: 4 to 4
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 18 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 2, 0.90234375, 0.95019531, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MUL R2.xy, fragment.texcoord[0].zwzw, c[1].x;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
TEX R2.x, R2, texture[1], 2D;
KIL -R0.w;
TEX R1.xyz, fragment.texcoord[3], texture[2], CUBE;
MOV R2.yzw, fragment.texcoord[2].xxyz;
MOV R0.w, c[4].y;
MAD_SAT R0.w, R0, -c[0].x, R2.x;
MUL R1.xyz, R1, c[3].x;
MUL R1.xyz, R1, R0.w;
MAD R0.xyz, fragment.color.primary, R0, R2.yzww;
MAD result.color.xyz, R0, c[4].x, R1;
MOV result.color.w, R0;
END
# 18 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_Reflection]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_2_0
; 17 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c4, 0.95019531, 1.00000000, 0.00000000, 0.90234375
def c5, 2.00000000, 0, 0, 0
dcl t0
dcl v0.xyz
dcl t2.xyz
dcl t3.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4
cmp r1.x, -r1, c4.y, -c4.y
cmp r1.x, r1, c4.z, c4.y
mov_pp r1, -r1.x
mov_pp r3.xyz, t2
mad_pp r3.xyz, r0, v0, r3
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
mov_pp r0.x, c0
texkill r1.xyzw
texld r2, r2, s1
texld r1, t3, s2
mad_pp_sat r0.x, c4.w, -r0, r2
mul_pp r1.xyz, r1, c3.x
mov_pp r0.w, r0.x
mul_pp r1.xyz, r1, r0.x
mad_pp r0.xyz, r3, c5.x, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 270


			}
		}		Fallback "Diffuse", 1
	}
}
