//
//  GLMTransform.h
//  glm
//
//  Created by 刘东旭 on 2024/1/20.
//

#import <Foundation/Foundation.h>

#ifndef GLMTransform_h
#define GLMTransform_h

#ifdef __cplusplus
extern "C" {
#endif

/// 创建平移变换
/// - Parameters:
///   - transX: X轴平移值
///   - transY: Y轴平移值
CGAffineTransform GLMAffineTransformMakeTranslate(float transX, float transY);

/// 创建基于transform的平移变换
/// - Parameters:
///   - transform: view的transform
///   - transX: X轴平移值
///   - transY: Y轴平移值
CGAffineTransform GLMAffineTransformTranslate(CGAffineTransform transform, float transX, float transY);

/// 创建仿射变换缩放
/// - Parameters:
///   - scale: 缩放比例
CGAffineTransform GLMAffineTransformMakeScale(float scale);


/// 创建带锚点仿射变换缩放
/// - Parameters:
///   - scale: 缩放比例
///   - anchor: 锚点，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform GLMAffineTransformMakeScaleAnchor(float scale, CGPoint anchor);

/// 创建仿射变换旋转
/// - Parameters:
///   - rotate: 旋转角度，弧度表示
CGAffineTransform GLMAffineTransformMakeRotation(float rotate);


/// 创建带锚点的仿射变换旋转
/// - Parameters:
///   - rotate: 旋转角度，弧度表示
///   - anchor: 锚点，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform GLMAffineTransformMakeRotationAnchor(float rotate, CGPoint anchor);


/// 仿射变换以某个锚点缩放
/// - Parameters:
///   - transform: view的transform
///   - scale: 缩放比例
///   - anchor: 锚点位置，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform GLMAffineTransformScaleAnchor(CGAffineTransform transform, float scale, CGPoint anchor);

/// 仿射变换以某个锚点旋转
/// - Parameters:
///   - transform: view的transform
///   - rotate: 旋转角度，弧度表示
///   - anchor: 锚点位置，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform GLMAffineTransformRotationAnchor(CGAffineTransform transform, float rotate, CGPoint anchor);

#ifdef __cplusplus
}
#endif

#endif //GLMTransform_h
