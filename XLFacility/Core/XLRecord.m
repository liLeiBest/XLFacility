/*
 Copyright (c) 2014, Pierre-Olivier Latour
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * The name of Pierre-Olivier Latour may not be used to endorse
 or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL PIERRE-OLIVIER LATOUR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#if !__has_feature(objc_arc)
#error XLFacility requires ARC
#endif

#import <pthread.h>

#import "XLRecord.h"

@implementation XLRecord

- (id)initWithAbsoluteTime:(CFAbsoluteTime)absoluteTime
                  logLevel:(XLLogLevel)logLevel
                   message:(NSString*)message
             capturedErrno:(int)capturedErrno
          capturedThreadID:(int)capturedThreadID
        capturedQueueLabel:(NSString*)capturedQueueLabel
                 callstack:(NSArray*)callstack {
  if ((self = [super init])) {
    _absoluteTime = absoluteTime;
    _logLevel = logLevel;
    _message = message;
    _capturedErrno = capturedErrno;
    _capturedThreadID = capturedThreadID;
    _capturedQueueLabel = capturedQueueLabel;
    _callstack = callstack;
  }
  return self;
}

- (id)initWithAbsoluteTime:(CFAbsoluteTime)absoluteTime logLevel:(XLLogLevel)logLevel message:(NSString*)message callstack:(NSArray*)callstack {
  const char* label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
  uint64_t threadID = 0;
  pthread_threadid_np(pthread_self(), &threadID);
  return [self initWithAbsoluteTime:absoluteTime
                           logLevel:logLevel
                            message:message
                      capturedErrno:errno
                   capturedThreadID:(int)threadID
                 capturedQueueLabel:(label[0] ? [NSString stringWithUTF8String:label] : nil)
                          callstack:callstack];
}

@end