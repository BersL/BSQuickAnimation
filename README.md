# 介绍
用Swift实现的快速动画框架，包括常用UIView动画以及CALayer动画

# 用法
将BSQuickAnimation.framework添加到工程，在Targets-> General-> Embedded Binaries中添加该framework，在文件中import BSQuickAnimation即可</br>
> For Objective-C: </br>需将Build Settings -> Build Options -> Embedded Content Contains Swift Code改为YES

### Swift Example:
```Swift
UIView.bs_animationOptions.defaultDuration = 2.0
UIView.bs_animationOptions.defaultCompletinoBlock = {
            (finished) -> Void in
            print("Animation Complete")
        }
        
let view = UIView(frame: CGRectMake(0, 0, 50, 50))
view.after(3.0).easeInOut.moveX(50).and.scale(1.5).then.after(2.0).easeIn.rotate(180)
````
### Objective-C Example:
```Objective-C
UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
// frequency = 0 for flickering forever
[[[[[view.layer moveX:50 duration:3.0] then] strokeEndfrom:0.0 to:1.0] then] flicker:0 period:0.1];
```
# 说明
默认参数：
* defaultDuration: 1.0s
* defaultTimingCuve: Liner

部分方法说明：
* barrier: 如果相应view有正在执行的动画（通过BSQuickAnimation执行）则barrier后调用的动画方法将被忽略。常用于防止重复动画。
* then: then后动画将在then之前所有动画（通过BSQuickAnimation执行）完成后执行
* and: and后调用动画方法将与and前动画方法共享相同delay
* bs_removeAnim:(NSUInteger)atIndex :移除第index个CALayer动画（通过BSQuickAnimation执行）
* bs_removeAll: 移除所有通过BSQuickAnimation执行的CALayer动画


