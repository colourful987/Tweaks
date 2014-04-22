/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import "UIColor+HEX.h"

@interface FBColorWheelView : UIControl

@property(nonatomic, readonly, assign) HSB hsb;

@end
