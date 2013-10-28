//
//  IPaMoviePlayerController.h
//
//  Created by IPaPa on 2011/6/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//================================
//  Important!!!!!
//  Have to include MediaPlayer.framework
//================================
#import <Foundation/Foundation.h>
@import MediaPlayer;

@interface IPaMoviePlayerController : MPMoviePlayerController {

}
@property (nonatomic,copy) void (^onExitFullScreen)();

+ (void)playMovieWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                       inView:(UIView*)inView
                  endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
+ (void)playMovieWithURL:(NSURL*)URL
                  inView:(UIView*)inView
             endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
+ (void)playMovieWithContentOfFile:(NSString*)filePath
                  inView:(UIView*)inView
             endCallback:(void (^)(IPaMoviePlayerController*))endCallback;


- (IPaMoviePlayerController*)initWithURL:(NSURL*)URL endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
- (IPaMoviePlayerController*)initWithContentOfFile:(NSString*)filePath endCallback:(void (^)(IPaMoviePlayerController*))endCallback;

- (IPaMoviePlayerController*)initWithResource:(NSString*)SourceName ofType:(NSString*)ofType;
- (IPaMoviePlayerController*)initWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                                       endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
- (void)setResource:(NSString*)SourceName ofType:(NSString*)ofType;
- (void)setContentFile:(NSString*)filePath;

- (void)playInView:(UIView*)view;

//just show not play
- (void)showInView:(UIView*)view;

- (void)closeMovie;
- (void)sizeToFit;

@end
