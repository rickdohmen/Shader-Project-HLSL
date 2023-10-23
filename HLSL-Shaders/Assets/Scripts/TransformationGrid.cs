using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TransformationGrid : MonoBehaviour
{
    List<Transformation> transformations;

    void Awake()
    {
        transformations = new List<Transformation>();
    }

    void Update()
    {
        GetComponents<Transformation>(transformations);
        for(int i = 0, z= 0; z < gridResolution; z++)
        {
            for(int y = 0; y < gridResolution; y++)
            {
                for(int x = 0; x < gridResolution; x++)
                {
                    grid[i].localPosition = TransformPoint(x, y, z);
                }
            }
        }
    }

    Vector3 TransformPoint(int x, int y, int z)
    {
        Vector3 coordinates = GetCoordinates(x, y, z);
        for (int i = 0; i < transformations.Count; i++)
        {
            coordinates = transformations[i].Apply(coordinates);
        }
        return coordinates;
    }
}
