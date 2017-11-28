/*
 Copyright (c) 2009 Ole Begemann
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

/*
 OBShapedButton.m
 
 Created by Ole Begemann
 October, 2009
 */

#import "OBShapedButton.h"
#import "UIImage+ColorAtPixel.h"

@interface OBShapedButton () {
    id  actionTarget;
    SEL touchAction;
    SEL longPressAction;
    NSTimer *longPressTimer;
    BOOL longPressNotComplete;
}

@property (nonatomic, assign) CGPoint previousTouchPoint;
@property (nonatomic, assign) BOOL previousTouchHitTestResponse;
@property (nonatomic, strong) UIImage *buttonImage;
@property (nonatomic, strong) UIImage *buttonBackground;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGR;

- (void)updateImageCacheForCurrentState;
- (void)resetHitTestCache;

@end


@implementation OBShapedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
//    _longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
//    [self addGestureRecognizer:_longPressGR];
}


- (void)addTarget:(id)target action:(SEL)action forResponseState:(ButtonClickType)state
{
    actionTarget = target;
    
    switch (state) {
        case ButtonClickType_LongPress:
            longPressAction = action;
            break;
        case ButtonClickType_TouchUpInside:
            touchAction = action;
            break;
        default:
            break;
    }
}

- (void)setLongPressTriggerDuration:(CFTimeInterval)duration
{
    if (_longPressGR) {
        _longPressGR.minimumPressDuration = duration;
    }
}

#pragma mark - Hit testing

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image
{
    // Correct point to take into account that the image does not have to be the same size
    // as the button. See https://github.com/ole/OBShapedButton/issues/1
    CGSize iSize = image.size;
    CGSize bSize = self.bounds.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;

    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        // available from iOS 5.0
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    else
    {
        // for iOS < 5.0
        // In iOS 6.1 this code is not working in release mode, it works only in debug
        // CGColorGetAlpha always return 0.
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    return alpha >= kAlphaVisibleThreshold;
}


// UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
// If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
// of the view hierarchy is ignored.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }

    // Don't check again if we just queried the same point
    // (because pointInside:withEvent: gets often called multiple times)
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }

    BOOL response = NO;
    
    if (self.buttonImage == nil && self.buttonBackground == nil) {
        response = YES;
    }
    else if (self.buttonImage != nil && self.buttonBackground == nil) {
        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonImage];
    }
    else if (self.buttonImage == nil && self.buttonBackground != nil) {
        response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
    }
    else {
        if ([self isAlphaVisibleAtPoint:point forImage:self.buttonImage]) {
            response = YES;
        } else {
            response = [self isAlphaVisibleAtPoint:point forImage:self.buttonBackground];
        }
    }
    
    self.previousTouchHitTestResponse = response;
    return response;
}


#pragma mark - Accessors

// Reset the Hit Test Cache when a new image is assigned to the button
- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state
{
    [super setBackgroundImage:image forState:state];
    [self updateImageCacheForCurrentState];
    [self resetHitTestCache];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self updateImageCacheForCurrentState];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self updateImageCacheForCurrentState];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self updateImageCacheForCurrentState];
}


#pragma mark - Helper methods

#pragma mark - 触摸事件执行
- (void)longPressGesture:(UILongPressGestureRecognizer*)longGesture {
    if (longGesture
        &&(longGesture.state == UIGestureRecognizerStateBegan || longGesture.state == UIGestureRecognizerStateChanged)) {
        if (longGesture.state == UIGestureRecognizerStateBegan) {
            longPressNotComplete = YES;
            if (longPressAction != nil) {
                //如果有长按执行事件，则初始化timer
                longPressTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(longPressTimerOut) userInfo:nil repeats:NO];
            }
        }
    }
    
    if (longGesture.state == UIGestureRecognizerStateEnded
        || longGesture.state == UIGestureRecognizerStateCancelled) {
        if (longPressTimer) {
            [longPressTimer invalidate];
        }
    }
    
    // 手势结束，同时未超时
    if (longGesture.state == UIGestureRecognizerStateEnded
        && longPressNotComplete) {
        // 取消长压定时器
        [self invalidateLongPressTimer];
        if (actionTarget && [actionTarget respondsToSelector:touchAction]) {
            [actionTarget performSelector:touchAction withObject:self afterDelay:0];
        }
    }

    // 由超时处理函数调用，触发长按事件
    if (longGesture == nil) {
        if (actionTarget &&[actionTarget respondsToSelector:longPressAction]) {
            [actionTarget performSelector:longPressAction withObject:self afterDelay:0];
        }
    }
}


- (void)longPressTimerOut {
    [self invalidateLongPressTimer];
    [self longPressGesture:nil];
}

- (void)invalidateLongPressTimer {
    longPressNotComplete = NO;
    [longPressTimer invalidate];
}

- (void)updateImageCacheForCurrentState
{
    _buttonBackground = [self currentBackgroundImage];
    _buttonImage = [self currentImage];
}

- (void)resetHitTestCache
{
    self.previousTouchPoint = CGPointMake(CGFLOAT_MIN, CGFLOAT_MIN);
    self.previousTouchHitTestResponse = NO;
}

@end
