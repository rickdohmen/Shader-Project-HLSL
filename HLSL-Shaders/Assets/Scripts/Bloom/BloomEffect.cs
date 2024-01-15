using UnityEngine;
using System;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class BloomEffect : MonoBehaviour
{
    [Range(1, 16)]
    public int iterations = 1;

    RenderTexture[] textures = new RenderTexture[16];


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int width = source.width / 2;
        int height = source.height / 2;
        RenderTextureFormat format = source.format;
        RenderTexture currentDestination = textures[0] = RenderTexture.GetTemporary(width, height, 0, format);

		Graphics.Blit(source, currentDestination);
        RenderTexture currentSource = currentDestination;

        for (int i = 1; i < iterations; i++)
        {
            width /= 2; height /= 2;
            if(height < 2)
            {
                break;
            }
            currentDestination = textures[i] = RenderTexture.GetTemporary(width, height, 0, format);
            Graphics.Blit(source, currentDestination);
            RenderTexture.ReleaseTemporary(currentDestination);
            currentSource = currentDestination;
        }

        Graphics.Blit(currentSource, destination);
        RenderTexture.ReleaseTemporary(currentSource);
    }
}