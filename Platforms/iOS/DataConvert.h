#pragma once

#define MakeStringCopy(x) (x != NULL && [x isKindOfClass:[NSString class]]) ? strdup([x UTF8String]) : NULL
