using UnityEngine;
using System;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class DepthOfFieldEffect : MonoBehaviour {

    [Range(0.1f, 200f)]
    public float focusDistance = 10f;

    [Range(0.1f, 500f)]
    public float focusRange = 3f;

    [Range(1f, 20f)]
    public float bokehRadius = 4f;

    public bool visualizeFocus;

    [SerializeField] private RenderTexture source;
    [SerializeField] private RenderTexture destination;


    [HideInInspector] public Shader dofShader;

    [SerializeField] private Material dofMaterial;

    const int circleOfCofusionPass = 0;
    const int preFilterPass = 1;
    const int bokehPass = 2;
    const int postFilerPass = 3;
    const int combinePass = 4;

    public struct DofSettings
	{
        [Range(1, 100)] public float focusDistance;
        [Range(1, 100)] public float focusRange;
        [Range(1f, 20f)] public float bokehRadius;
    }

    private void OnEnable()
    {
        if (dofShader == null)
        {
            dofShader = Shader.Find("Hidden/DepthOfField");
        }

        if (dofShader == null)
        {
            Debug.LogError("Depth of Field shader not found. Please assign it in the inspector.");
            enabled = false;
        }
        else
        {
            dofMaterial = new Material(dofShader); // Move the material creation to OnEnable
            dofMaterial.hideFlags = HideFlags.HideAndDontSave;
        }
    }

    private void FixedUpdate() 
	{
		if (dofMaterial == null) {
			dofMaterial = new Material(dofShader);
			dofMaterial.hideFlags = HideFlags.HideAndDontSave;
		}

		

		dofMaterial.SetFloat("_BokehRadius", bokehRadius);
		dofMaterial.SetFloat("_FocusDistance", focusDistance);
		dofMaterial.SetFloat("_FocusRange", focusRange);

		RenderTexture coc = RenderTexture.GetTemporary(
			source.width, source.height, 0,
			RenderTextureFormat.RHalf, RenderTextureReadWrite.Linear
		);

		int width = source.width / 2;
		int height = source.height / 2;
		RenderTextureFormat format = source.format;
		RenderTexture dof0 = RenderTexture.GetTemporary(width, height, 0, format);
		RenderTexture dof1 = RenderTexture.GetTemporary(width, height, 0, format);

		dofMaterial.SetTexture("_CoCTex", coc);
		dofMaterial.SetTexture("_DoFTex", dof0);

		Graphics.Blit(source, coc, dofMaterial, circleOfCofusionPass);
		Graphics.Blit(source, dof0, dofMaterial, preFilterPass);
		Graphics.Blit(dof0, dof1, dofMaterial, bokehPass);
		Graphics.Blit(dof1, dof0, dofMaterial, postFilerPass);
		Graphics.Blit(source, destination, dofMaterial, combinePass);

		RenderTexture.ReleaseTemporary(coc);
		RenderTexture.ReleaseTemporary(dof0);
		RenderTexture.ReleaseTemporary(dof1);
	}
}