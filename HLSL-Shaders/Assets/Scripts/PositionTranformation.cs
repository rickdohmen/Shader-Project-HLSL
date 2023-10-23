using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PositionTranformation : Transformation
{
    public Vector3 position;

    public override Vector3 apply(Vector3 point)
    {
        return point + position;
    }

    
}
