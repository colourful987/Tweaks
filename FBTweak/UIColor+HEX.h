/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

typedef struct { CGFloat red, green, blue; } RGB;
typedef struct { CGFloat hue, saturation, brightness; } HSB;

extern void RGB2HSB(RGB rgb, HSB* outHSB);
extern void HSB2RGB(HSB hsb, RGB* outRGB);

@interface UIColor (HEX)

- (NSString*)hexString;
+ (UIColor*)colorWithHexString:(NSString*)hexColor;

@end
