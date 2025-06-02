#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NewrelicMobilePlugin.h"

FOUNDATION_EXPORT double newrelic_mobileVersionNumber;
FOUNDATION_EXPORT const unsigned char newrelic_mobileVersionString[];

