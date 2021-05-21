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

#import "WebViewJavascriptBridge.h"
#import "WebViewJavascriptBridgeBase.h"

FOUNDATION_EXPORT double WebViewJavascriptBridge_WebKitVersionNumber;
FOUNDATION_EXPORT const unsigned char WebViewJavascriptBridge_WebKitVersionString[];

