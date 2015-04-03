/*
 * SB - Engine
 * Author:		Gerhard Zeissl
 * Date:		01012015
 *
 */

#define Singleton(classname)\
\
static classname *shared##classname = nil; \
\
+ (classname *)instance \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [[self alloc] initSingleton]; \
} \
} \
\
return shared##classname; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##classname == nil) \
{ \
shared##classname = [super allocWithZone:zone]; \
return shared##classname; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\

#define SingletonInit + (instancetype)instance;- (instancetype)initSingleton;