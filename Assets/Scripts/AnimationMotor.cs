using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

public class AnimationMotor : MonoBehaviour {
	public string[] animationName;
	public AnimationClip[] animationClip;
	public float[] animationSpeed;
	
	private Dictionary<string, AnimationClip> animations = new Dictionary<string, AnimationClip>();
	private Dictionary<string, float> animationSpeeds = new Dictionary<string, float>();
	
	void Start() {
		for(int i=0;i<animationName.Length;i++) {
			animations.Add(animationName[i].ToLower(), animationClip[i]);
			animationSpeeds.Add(animationName[i].ToLower(), animationSpeed[i]);
		}
	}
	
	public float getAnimationSpeed(string state) {
		float animationSpeed;
		if(!animationSpeeds.TryGetValue(state.ToLower(), out animationSpeed)) {
			Debug.LogError("Could not get animation speed for state "+state);
		}
		return animationSpeed;
	}
	
	public AnimationClip getAnimation(string state) {
		AnimationClip clip;
		if(!animations.TryGetValue(state.ToLower(), out clip)) {
			Debug.LogError("Could not get animation clip for state "+state);
		}
		return clip;
	}
	
	public bool keyExists(string state) {
		return animations.ContainsKey(state.ToLower());
	}
	
	public void Play(string state) {
		string animationName = this.getAnimation(state).name;
		animation[animationName].speed = this.getAnimationSpeed(state);
		animation.Play(animationName);
	}
}
