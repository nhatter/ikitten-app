Shader "FurFX/Mobile/FurFX Unlit 10 Layer"
{
	Properties
	{
		_Color ("Color (RGB)", Color) = (1,1,1,1)
	  	_SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  	_Shininess ("Shininess", Range (0.01, 10)) = 8		
		_FurLength ("Fur Length", Range (.0002, 0.5)) = .05
		_MainTex ("Base (RGB) Mask(A)", 2D) = "white" { }
		_NoiseTex ("Noise (RGB)", 2D) = "white" { }
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
		Blend SrcAlpha OneMinusSrcAlpha
		
		SubShader
		{
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 11 to 11
//   d3d9 - ALU: 11 to 11
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Float 13 [_FurLength]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"!!ARBvp1.0
# 11 ALU
PARAM c[19] = { { 0, 1 },
		program.local[1..4],
		state.matrix.mvp,
		program.local[9..18] };
TEMP R0;
MOV R0.x, c[13];
MUL R0.x, R0, c[0];
MOV R0.w, c[0].y;
ADD R0.xyz, vertex.position, R0.x;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[16];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[18].xyxy, c[18];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[17], c[17].zwzw;
END
# 11 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Matrix 4 [glstate_matrix_mvp]
Float 12 [_FurLength]
Vector 13 [_Color]
Vector 14 [_MainTex_ST]
Vector 15 [_NoiseTex_ST]
"vs_2_0
; 11 ALU
def c16, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
mov r0.x, c16
mul r0.x, c12, r0
mov r0.w, c16.y
add r0.xyz, v0, r0.x
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c13
mad oT0.zw, v1.xyxy, c15.xyxy, c15
mad oT0.xy, v1, c14, c14.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;

uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = _glesVertex.xyz;
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = P;
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
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

#LINE 36

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.099975586, -1, 1, 0.010000001 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.09997559, 1.00000000, -1.00000000, 0.01000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.1) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.01) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.010002136, 0.65625, 0.099975586, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.65625000, 0.01000214, 0.09997559, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 48

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.19995117, -1, 1, 0.040000003 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.19995117, 1.00000000, -1.00000000, 0.04000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.2) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.04) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.040008545, 0.40966797, 0.19995117, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.40966797, 0.04000854, 0.19995117, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 60

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.30004883, -1, 1, 0.090000004 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.30004883, 1.00000000, -1.00000000, 0.09000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.3) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.09) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.090026855, 0.2401123, 0.30004883, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.24011230, 0.09002686, 0.30004883, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 72

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.39990234, -1, 1, 0.16000001 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.39990234, 1.00000000, -1.00000000, 0.16000001
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.4) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.16) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.16003418, 0.12963867, 0.39990234, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.12963867, 0.16003418, 0.39990234, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 84

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.5, -1, 1, 0.25 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.50000000, 1.00000000, -1.00000000, 0.25000000
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.5) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.25) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.25, 0.0625, 0.5, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.06250000, 0.25000000, 0.50000000, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 96

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.60009766, -1, 1, 0.36000001 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.60009766, 1.00000000, -1.00000000, 0.36000001
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.6) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.36) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.36010742, 0.025604248, 0.60009766, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.02560425, 0.36010742, 0.60009766, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 108

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.70019531, -1, 1, 0.48999998 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.70019531, 1.00000000, -1.00000000, 0.48999998
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.7) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.49) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.48999023, 0.008102417, 0.70019531, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00810242, 0.48999023, 0.70019531, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 120

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.79980469, -1, 1, 0.64000005 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.79980469, 1.00000000, -1.00000000, 0.64000005
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.8) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.64) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.64013672, 0.0016002655, 0.79980469, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00160027, 0.64013672, 0.79980469, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 132

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 27 to 27
//   d3d9 - ALU: 28 to 28
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 27 ALU
PARAM c[20] = { { 0.89990234, -1, 1, 0.80999994 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].z;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].y;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].y;
MOV R0.w, c[0].z;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
MUL R1.xyz, R1, c[0].x;
MUL R0.xyz, R0, c[0].w;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 27 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 28 ALU
def c19, 0.89990234, 1.00000000, -1.00000000, 0.80999994
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.y, r0
max r0, r0, c19.z
mov r1, c14
min r1, c19.y, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.z
mov r0.w, c19.y
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
mul r1.xyz, r1, c19.x
mul r0.xyz, r0, c19.w
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + (((normalize (_glesNormal) * _FurLength) * 0.9) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + ((((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * 0.81) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _HairShading;
uniform lowp float _EdgeFade;
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
  o.xyz = (o.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 13 to 13, TEX: 2 to 2
//   d3d9 - ALU: 14 to 14, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 13 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.81005859, 0.00010001659, 0.89990234, -1 },
		{ 1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R1.x, R0.w, c[2];
MOV R1.zw, c[4].xyxy;
MAD R0.xyz, R1.w, -c[3].x, R0;
ADD R1.x, -R1, c[4].z;
MOV R0.w, c[5].x;
CMP R0.w, -R1.x, c[4], R0;
SLT R0.w, R0, c[5].y;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
MAD_SAT result.color.w, R1.z, -c[0].x, R1.x;
END
# 13 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
Float 3 [_HairShading]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 14 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c4, 0.00010002, 0.81005859, 0.89990234, 1.00000000
def c5, 0.00000000, 1.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c4.z
cmp r1.x, -r1, c4.w, -c4.w
cmp r1.x, r1, c5, c5.y
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
texkill r1.xyzw
texld r1, r2, s1
mov_pp r2.x, c3
mad_pp r2.xyz, c4.x, -r2.x, r0
mov_pp r0.x, c0
mad_pp_sat r0.w, c4.y, -r0.x, r1.x
mul_pp r0.xyz, r2, v0
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 144

			}
			Pass
			{
				Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 25 to 25
//   d3d9 - ALU: 26 to 26
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 9 [_World2Object]
Float 13 [_FurLength]
Vector 14 [_ForceGlobal]
Vector 15 [_ForceLocal]
Float 16 [_HairHardness]
Vector 17 [_Color]
Vector 18 [_MainTex_ST]
Vector 19 [_NoiseTex_ST]
"!!ARBvp1.0
# 25 ALU
PARAM c[20] = { { -1, 1 },
		state.matrix.projection,
		state.matrix.mvp,
		program.local[9..19] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.x, c[0].y;
MIN R0, R1.x, c[14];
MAX R0, R0, c[0].x;
MIN R1, R1.x, c[15];
DP4 R2.z, R0, c[11];
DP4 R2.y, R0, c[10];
DP4 R2.x, R0, c[9];
MAX R1, R1, c[0].x;
MOV R0.w, c[0].y;
DP4 R0.z, R1, c[3];
DP4 R0.y, R1, c[2];
DP4 R0.x, R1, c[1];
MUL R1.xyz, vertex.normal, c[13].x;
ADD R0.xyz, R2, R0;
MUL R1.xyz, R1, c[16].x;
MUL R0.xyz, R0, c[13].x;
ADD R1.xyz, vertex.position, R1;
ADD R0.xyz, R1, R0;
DP4 result.position.w, R0, c[8];
DP4 result.position.z, R0, c[7];
DP4 result.position.y, R0, c[6];
DP4 result.position.x, R0, c[5];
MOV result.color, c[17];
MAD result.texcoord[0].zw, vertex.texcoord[0].xyxy, c[19].xyxy, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 25 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_projection]
Matrix 4 [glstate_matrix_mvp]
Matrix 8 [_World2Object]
Float 12 [_FurLength]
Vector 13 [_ForceGlobal]
Vector 14 [_ForceLocal]
Float 15 [_HairHardness]
Vector 16 [_Color]
Vector 17 [_MainTex_ST]
Vector 18 [_NoiseTex_ST]
"vs_2_0
; 26 ALU
def c19, 1.00000000, -1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r0, c13
min r0, c19.x, r0
max r0, r0, c19.y
mov r1, c14
min r1, c19.x, r1
dp4 r2.z, r0, c10
dp4 r2.y, r0, c9
dp4 r2.x, r0, c8
max r1, r1, c19.y
mov r0.w, c19.x
dp4 r0.z, r1, c2
dp4 r0.y, r1, c1
dp4 r0.x, r1, c0
mul r1.xyz, v1, c12.x
add r0.xyz, r2, r0
mul r1.xyz, r1, c15.x
mul r0.xyz, r0, c12.x
add r1.xyz, v0, r1
add r0.xyz, r1, r0
dp4 oPos.w, r0, c7
dp4 oPos.z, r0, c6
dp4 oPos.y, r0, c5
dp4 oPos.x, r0, c4
mov oD0, c16
mad oT0.zw, v2.xyxy, c18.xyxy, c18
mad oT0.xy, v2, c17, c17.zwzw
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

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;


uniform highp mat4 _World2Object;
uniform mediump vec4 _NoiseTex_ST;
uniform mediump vec4 _MainTex_ST;
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
  lowp vec3 P;
  mediump vec4 tmpvar_1;
  tmpvar_1.xy = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_1.zw = ((_glesMultiTexCoord0.xy * _NoiseTex_ST.xy) + _NoiseTex_ST.zw);
  highp vec3 tmpvar_2;
  tmpvar_2 = (_glesVertex.xyz + ((normalize (_glesNormal) * _FurLength) * _HairHardness));
  P = tmpvar_2;
  highp vec3 tmpvar_3;
  tmpvar_3 = (P + (((_World2Object * clamp (_ForceGlobal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz + (gl_ProjectionMatrix * clamp (_ForceLocal, vec4(-1.0, -1.0, -1.0, -1.0), vec4(1.0, 1.0, 1.0, 1.0))).xyz) * _FurLength));
  P = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = P;
  gl_Position = (gl_ModelViewProjectionMatrix * tmpvar_4);
  xlv_TEXCOORD0 = tmpvar_1;
  xlv_COLOR0 = _Color;
}



#endif
#ifdef FRAGMENT

varying lowp vec4 xlv_COLOR0;
varying mediump vec4 xlv_TEXCOORD0;
uniform lowp float _SkinAlpha;
uniform sampler2D _NoiseTex;
uniform sampler2D _MainTex;
uniform lowp float _HairThinness;
uniform lowp float _EdgeFade;
void main ()
{
  lowp vec4 o;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  o = tmpvar_1;
  lowp float tmpvar_2;
  tmpvar_2 = max (tmpvar_1.w, _SkinAlpha);
  int tmpvar_3;
  if ((1.0 > tmpvar_2)) {
    tmpvar_3 = -1;
  } else {
    tmpvar_3 = 1;
  };
  float x;
  x = float(tmpvar_3);
  if ((x < 0.0)) {
    discard;
  };
  o.xyz = tmpvar_1.xyz;
  o.w = clamp ((texture2D (_NoiseTex, (xlv_TEXCOORD0.zw * _HairThinness)).xyz - _EdgeFade), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)).x;
  o.xyz = (tmpvar_1.xyz * xlv_COLOR0.xyz);
  gl_FragData[0] = o;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 10 to 10, TEX: 2 to 2
//   d3d9 - ALU: 11 to 11, TEX: 3 to 3
SubProgram "opengl " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 10 ALU, 2 TEX
PARAM c[4] = { program.local[0..2],
		{ 1, -1, 0 } };
TEMP R0;
TEMP R1;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MAX R0.w, R0, c[2].x;
ADD R0.w, -R0, c[3].x;
CMP R0.w, -R0, c[3].y, c[3].x;
SLT R0.w, R0, c[3].z;
MUL R1.xy, fragment.texcoord[0].zwzw, c[1].x;
MUL result.color.xyz, R0, fragment.color.primary;
TEX R1.x, R1, texture[1], 2D;
KIL -R0.w;
ADD_SAT result.color.w, R1.x, -c[0].x;
END
# 10 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Float 0 [_EdgeFade]
Float 1 [_HairThinness]
Float 2 [_SkinAlpha]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_NoiseTex] 2D
"ps_2_0
; 11 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
def c3, 1.00000000, 0.00000000, 0, 0
dcl t0
dcl v0.xyz
texld r0, t0, s0
max_pp r1.x, r0.w, c2
add_pp r1.x, -r1, c3
cmp r1.x, -r1, c3, -c3
cmp r1.x, r1, c3.y, c3
mov_pp r1, -r1.x
mov r2.y, t0.w
mov r2.x, t0.z
mul_pp r2.xy, r2, c1.x
mul_pp r0.xyz, r0, v0
texld r2, r2, s1
texkill r1.xyzw
add_pp_sat r0.w, r2.x, -c0.x
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

}

#LINE 156


			}
		}		Fallback "Diffuse", 1
	}
}
