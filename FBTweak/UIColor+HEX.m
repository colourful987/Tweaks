/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "UIColor+HEX.h"

/**
 * Converts an RGB color value to HSV.
 * Assumes r, g, and b are contained in the set [0, 255] and
 * returns h, s, and v in the set [0, 1].
 *
 *  @param rgb   The rgb color values
 *  @param outHSB The hsb color values
 */
extern void RGB2HSB(RGB rgb, HSB* outHSB)
{
  double rd = (double) rgb.red / 255;
  double gd = (double) rgb.green / 255;
  double bd = (double) rgb.blue / 255;
  double max = fmax(rd, fmax(gd, bd));
  double min = fmin(rd, fmin(gd, bd));
  double h, s, b = max;

  double d = max - min;
  s = max == 0 ? 0 : d / max;

  if (max == min) {
    h = 0; // achromatic
  } else {
    if (max == rd) {
      h = (gd - bd) / d + (gd < bd ? 6 : 0);
    } else if (max == gd) {
      h = (bd - rd) / d + 2;
    } else if (max == bd) {
      h = (rd - gd) / d + 4;
    }
    h /= 6;
  }

  outHSB->hue = h;
  outHSB->saturation = s;
  outHSB->brightness = b;
}

/**
 * Converts an HSB color value to RGB.
 * Assumes h, s, and v are contained in the set [0, 1] and
 * returns r, g, and b in the set [0, 255].
 *
 *  @param outRGB   The rgb color values
 *  @param hsb The hsb color values
 */
extern void HSB2RGB(HSB hsb, RGB* outRGB)
{
  double r, g, b;

  int i = hsb.hue * 6;
  double f = hsb.hue * 6 - i;
  double p = hsb.brightness * (1 - hsb.saturation);
  double q = hsb.brightness * (1 - f * hsb.saturation);
  double t = hsb.brightness * (1 - (1 - f) * hsb.saturation);

  switch(i % 6){
    case 0: r = hsb.brightness, g = t, b = p; break;
    case 1: r = q, g = hsb.brightness, b = p; break;
    case 2: r = p, g = hsb.brightness, b = t; break;
    case 3: r = p, g = q, b = hsb.brightness; break;
    case 4: r = t, g = p, b = hsb.brightness; break;
    case 5: r = hsb.brightness, g = p, b = q; break;
  }

  outRGB->red = r;
  outRGB->green = g;
  outRGB->blue = b;
}

@implementation UIColor (HEX)

- (NSString *)hexString
{
  CGColorSpaceModel colorSpaceModel = CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor));
  if (colorSpaceModel != kCGColorSpaceModelRGB && colorSpaceModel != kCGColorSpaceModelMonochrome) {
    return nil;
  }
  const CGFloat *components = CGColorGetComponents(self.CGColor);
  CGFloat red, green, blue, alpha;
  if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
    red = green = blue = components[0];
    alpha = components[1];
  } else {
    red = components[0];
    green = components[1];
    blue = components[2];
    alpha = components[3];
  }
  NSString *hexColorString = [NSString stringWithFormat:@"#%02X%02X%02X%02X",
                              (NSUInteger)(red * 255), (NSUInteger)(green * 255), (NSUInteger)(blue * 255), (NSUInteger)(alpha * 255)];
  return hexColorString;
}

+ (UIColor*)colorWithHexString:(NSString*)hexColor
{
  if (![hexColor hasPrefix:@"#"]) {
    return nil;
  }

  NSScanner *scanner = [NSScanner scannerWithString:hexColor];
  [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];

  unsigned hexNum;
  if (![scanner scanHexInt: &hexNum]) return nil;

  int r = (hexNum >> 24) & 0xFF;
  int g = (hexNum >> 16) & 0xFF;
  int b = (hexNum >> 8) & 0xFF;
  int a = (hexNum) & 0xFF;

  return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a / 255.0f];
}

@end
