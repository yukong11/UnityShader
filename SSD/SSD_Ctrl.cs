using UnityEngine;
using UnityEditor;
using System.Collections;
[ExecuteInEditMode] 
public class SSD_Ctrl : MonoBehaviour {
	
	public Camera m_camera = null;
	void Start () {
		m_camera = Camera.main;
		if (m_camera != null) {
			m_camera.depthTextureMode |= DepthTextureMode.Depth;
		}
	}

	void OnPreRender () {
		if (m_camera == null)
			return;
		GameObject root = GameObject.Find("DecalRoot");
		if (root == null)
			return;
		for ( int i = 0; i< root.transform.childCount;i++)
		{
			GameObject obj = root.transform.GetChild(i).gameObject;
			if( obj != null ||obj.renderer != null && obj.renderer.sharedMaterial != null)
			{
				Matrix4x4 m = obj.renderer.localToWorldMatrix;
				Matrix4x4 v = m_camera.worldToCameraMatrix;
				Matrix4x4 p =  GL.GetGPUProjectionMatrix(Camera.main.projectionMatrix, false);
				Matrix4x4 mvp = p*v*m;
				Shader.SetGlobalMatrix("_invMVP", mvp.inverse);
			}
		}
	}
}
