//
//  ViewController.m
//  glm
//
//  Created by 刘东旭 on 2024/1/20.
//

#import "ViewController.h"
#import "GLMTransform.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *testView;

@end

@implementation ViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    pinch.delegate = self;
    [self.view addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotate = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateAction:)];
    rotate.delegate = self;
    [self.view addGestureRecognizer:rotate];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    if (gesture.numberOfTouches > 1) {
        return;
    }
    CGPoint translation = [gesture translationInView:self.view];
    self.testView.transform = GLMAffineTransformTranslate(self.testView.transform, translation.x, translation.y);
    [gesture setTranslation:CGPointZero inView:self.view];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)pinch {
    float scale = pinch.scale;
    self.testView.transform = GLMAffineTransformScaleAnchor(self.testView.transform, scale, CGPointMake(-120, 64));
    pinch.scale = 1;
}

- (void)rotateAction:(UIRotationGestureRecognizer *)rotation {
    float rotate = rotation.rotation;
    NSLog(@"rotateAction:%f",rotate);
    self.testView.transform = GLMAffineTransformRotationAnchor(self.testView.transform, rotate, CGPointMake(-120, 64));
    rotation.rotation = 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return true;
}

/// 仿射变换以某个锚点缩放
/// - Parameters:
///   - transform: view的transform
///   - scale: 缩放比例
///   - anchor: 锚点位置，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform CGAffineTransformScaleAnchor(CGAffineTransform transform, float scale, CGPoint anchor) {
    /// 先将锚点位置移动到中心点
    CGAffineTransform traslation = CGAffineTransformMakeTranslation(-anchor.x, anchor.y);
    /// 创建scale的变换，以中心点缩放
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    /// 先移动后缩放
    CGAffineTransform tempTransform = CGAffineTransformConcat(traslation, scaleTransform);
    /// 将变换后的锚点移动到原位置
    tempTransform = CGAffineTransformConcat(tempTransform, CGAffineTransformInvert(traslation));
    /// 将视图应用当前变换
    return CGAffineTransformConcat(transform, tempTransform);
}

/// 仿射变换以某个锚点旋转
/// - Parameters:
///   - transform: view的transform
///   - rotate: 旋转角度，弧度表示
///   - anchor: 锚点位置，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform CGAffineTransformRotationAnchor(CGAffineTransform transform, float rotate, CGPoint anchor) {
    // 创建平移的transform以将旋转中心移动到视图的中心
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(-anchor.x, anchor.y);
    // 创建旋转的transform
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotate);
    // 将旋转和平移的transform进行合并
    CGAffineTransform finalTransform = CGAffineTransformConcat(translationTransform, rotationTransform);
    finalTransform = CGAffineTransformConcat(finalTransform, CGAffineTransformInvert(translationTransform));
    return CGAffineTransformConcat(transform,finalTransform);
}

/// 创建仿射变换以某个锚点旋转
/// - Parameters:
///   - rotate: 旋转角度，弧度表示
///   - anchor: 锚点位置，以view中心点为(0，0),左右为宽度的一半，上下为高度的一半
CGAffineTransform CGAffineTransformMakeRotationAnchor(float rotate, CGPoint anchor) {
    // 创建平移的transform以将旋转中心移动到视图的中心
    CGAffineTransform translationTransform = CGAffineTransformMakeTranslation(-anchor.x, anchor.y);
    // 创建旋转的transform
    CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(rotate);
    // 将旋转和平移的transform进行合并
    CGAffineTransform finalTransform = CGAffineTransformConcat(translationTransform, rotationTransform);
    finalTransform = CGAffineTransformConcat(finalTransform,CGAffineTransformInvert(translationTransform));
    return finalTransform;
}

@end
