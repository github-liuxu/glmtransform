//
//  GLMTransform.m
//  glm
//
//  Created by 刘东旭 on 2024/1/20.
//

#import "GLMTransform.h"
#import <CoreGraphics/CoreGraphics.h>
#include <glm/glm.hpp>
#include <glm/ext.hpp>

#define GLM_FORCE_COLUMN_MAJOR
#define GLM_EXPORT extern "C"

GLM_EXPORT CGAffineTransform convertToCGAffineTransform(const glm::mat4& matrix) {
    CGAffineTransform transform;
    // 提取矩阵元素并放入 CGAffineTransform 中
    transform.a = matrix[0][0];
    transform.b = matrix[1][0];
    transform.c = matrix[0][1];
    transform.d = matrix[1][1];
    transform.tx = matrix[3][0];
    transform.ty = matrix[3][1];
    return transform;
}

GLM_EXPORT CGAffineTransform GLMAffineTransformMakeTranslate(float transX, float transY) {
    glm::mat4 translateMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(transX, transY, 0));
    CGAffineTransform transform = convertToCGAffineTransform(translateMatrix);
    return transform;
}

GLM_EXPORT CGAffineTransform GLMAffineTransformTranslate(CGAffineTransform transform, float transX, float transY) {
    glm::mat4 translateMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(transX, transY, 0));
    CGAffineTransform finalMatrix = convertToCGAffineTransform(translateMatrix);
    return CGAffineTransformConcat(transform, finalMatrix);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformMakeScale(float scale) {
    return GLMAffineTransformScaleAnchor(CGAffineTransformIdentity, scale, CGPointZero);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformMakeScaleAnchor(float scale, CGPoint anchor) {
    return GLMAffineTransformScaleAnchor(CGAffineTransformIdentity, scale, anchor);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformScaleAnchor(CGAffineTransform transform, float scale, CGPoint anchor) {
    // 将左手坐标系转换为右手
    glm::mat4 scaleMatrixTransform = glm::scale(glm::mat4(1.0f), glm::vec3(1, -1, 1));
    // 将锚点移动到中心点
    glm::mat4 translateMatrix = glm::translate(glm::mat4(1.0f), glm::vec3(anchor.x, anchor.y, 0));
    // 以中心点缩放
    glm::mat4 scaleMatrix = glm::scale(glm::mat4(1.0f), glm::vec3(scale, scale, 1));
    // 将缩放应用到锚点, 并将锚点移动到原位置
    glm::mat4 tmat = scaleMatrixTransform * translateMatrix * scaleMatrix * glm::inverse(translateMatrix);
//    glm::mat4 tmat = glm::inverse(translateMatrix) * scaleMatrix * translateMatrix;
    CGAffineTransform tempTransform = convertToCGAffineTransform(tmat);
    /// 将视图应用当前变换
    return CGAffineTransformConcat(transform, tempTransform);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformMakeRotation(float rotate) {
    return GLMAffineTransformRotationAnchor(CGAffineTransformIdentity, rotate, CGPointZero);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformMakeRotationAnchor(float rotate, CGPoint anchor) {
    return GLMAffineTransformRotationAnchor(CGAffineTransformIdentity, rotate, anchor);
}

GLM_EXPORT CGAffineTransform GLMAffineTransformRotationAnchor(CGAffineTransform transform, float rotate, CGPoint anchor) {
    float r = rotate*180/M_PI;
    // 将左手坐标系转换为右手
    glm::mat4 scaleMatrix = glm::scale(glm::mat4(1.0f), glm::vec3(1, -1, 1));
    glm::mat4 translateToOrigin = glm::translate(glm::mat4(1.0f), glm::vec3(anchor.x, anchor.y, 0));
    glm::mat4 rotateMatrix = glm::rotate(glm::mat4(1.0f), -r, glm::vec3(0.0f, 0.0f, 1.0f));
    glm::mat4 translateBack = glm::inverse(translateToOrigin);
    glm::mat4 matrix = scaleMatrix * translateToOrigin * rotateMatrix * translateBack;
    CGAffineTransform tempTransform = convertToCGAffineTransform(matrix);
    tempTransform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, -1), tempTransform);
    return CGAffineTransformConcat(transform, tempTransform);
}
