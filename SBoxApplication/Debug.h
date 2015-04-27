//
//  Debug.h
//  SBoxApplication
//
//  Created by snowkrash on 27.04.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Log.h"

#define GENERATEMOCKUPDATA

#ifdef DEBUG
#define NSLog(...)                      LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"NSLog", 0, __VA_ARGS__)
#define Log(level, ...)         LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Error", level, __VA_ARGS__)
#define LoggerApp(level, ...)           LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"App", level, __VA_ARGS__)
#define LoggerView(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"View", level, __VA_ARGS__)
#define LoggerService(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Service", level, __VA_ARGS__)
#define LoggerModel(level, ...)         LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Model", level, __VA_ARGS__)
#define LoggerData(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Data", level, __VA_ARGS__)
#define LoggerNetwork(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Network", level, __VA_ARGS__)
#define LoggerLocation(level, ...)      LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Location", level, __VA_ARGS__)
#define LoggerPush(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Push", level, __VA_ARGS__)
#define LoggerFile(level, ...)          LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"File", level, __VA_ARGS__)
#define LoggerSharing(level, ...)       LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Sharing", level, __VA_ARGS__)
#define LoggerAd(level, ...)            LogMessageF(__FILE__, __LINE__, __FUNCTION__, @"Ad and Stat", level, __VA_ARGS__)

#else
#define NSLog(...)                      LogMessageCompat(__VA_ARGS__)
#define LoggerError(...)                while(0) {}
#define LoggerApp(level, ...)           while(0) {}
#define LoggerView(...)                 while(0) {}
#define LoggerService(...)              while(0) {}
#define LoggerModel(...)                while(0) {}
#define LoggerData(...)                 while(0) {}
#define LoggerNetwork(...)              while(0) {}
#define LoggerLocation(...)             while(0) {}
#define LoggerPush(...)                 while(0) {}
#define LoggerFile(...)                 while(0) {}
#define LoggerSharing(...)              while(0) {}
#define LoggerAd(...)                   while(0) {}

#endif

@interface Debug : NSObject

@end
