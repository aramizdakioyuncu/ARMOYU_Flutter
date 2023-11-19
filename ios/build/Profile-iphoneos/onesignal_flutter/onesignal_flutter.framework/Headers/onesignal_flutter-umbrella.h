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

#import "OneSignalPlugin.h"
#import "OSFlutterCategories.h"
#import "OSFlutterDebug.h"
#import "OSFlutterInAppMessages.h"
#import "OSFlutterLiveActivities.h"
#import "OSFlutterLocation.h"
#import "OSFlutterNotifications.h"
#import "OSFlutterPushSubscription.h"
#import "OSFlutterSession.h"
#import "OSFlutterUser.h"

FOUNDATION_EXPORT double onesignal_flutterVersionNumber;
FOUNDATION_EXPORT const unsigned char onesignal_flutterVersionString[];

