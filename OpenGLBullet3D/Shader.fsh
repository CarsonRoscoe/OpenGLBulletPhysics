//
//  Shader.fsh
//  Assignment1
//
//  Created by Carson Roscoe on 2017-02-08.
//  Copyright © 2017 Carson Roscoe. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
