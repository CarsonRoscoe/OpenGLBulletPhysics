precision mediump float;
attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoordIn;
varying vec3 eyeNormal;
varying vec4 eyePos;
varying vec2 texCoordOut;
uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;

void main()
{
    eyeNormal = (normalMatrix * normal);
    eyePos = modelViewMatrix * position;
    texCoordOut = texCoordIn;
    gl_Position = modelViewProjectionMatrix * position;
}
