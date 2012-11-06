//
//  IPaMoviePlayerController.m
//
//  Created by IPaPa on 2011/6/24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IPaMoviePlayerController.h"




@implementation IPaMoviePlayerController
{
    void (^EndCallback)(IPaMoviePlayerController*);
}
static NSMutableArray *moviePlayerList;
+(void)RetainPlayer:(IPaMoviePlayerController*)player
{
    if (moviePlayerList == nil) {
        moviePlayerList = [@[] mutableCopy];
    }
    if ([moviePlayerList indexOfObject:player] == NSNotFound)
    {
        [moviePlayerList addObject:player];
    }
    
}
+(void)ReleasePlayer:(IPaMoviePlayerController*)player
{
    [moviePlayerList removeObject:player];
}

-(void)onExitFullScreen:(NSNotification*)notification
{
    if (self.onExitFullScreen != nil) {
        self.onExitFullScreen();
    }
}
-(void)onEndOfPlay:(NSNotification*)notification
{
    if (EndCallback != nil) {
        EndCallback(self);
    }
    
}

-(void)onPlaybackStateChange:(NSNotification*)noti
{
    NSLog(@"PlaybackStateChange!");
}
//@synthesize delegate;
+ (void)playMovieWithURL:(NSURL*)URL
                  inView:(UIView*)inView
             endCallback:(void (^)(IPaMoviePlayerController*))endCallback
{
    IPaMoviePlayerController *theMovie = [[IPaMoviePlayerController alloc] initWithURL:URL endCallback:endCallback];
    [theMovie playInView:inView];
}
+ (void)playMovieWithContentOfFile:(NSString*) filePath
                            inView:(UIView*)inView
                       endCallback:(void (^)(IPaMoviePlayerController*))endCallback
{
    IPaMoviePlayerController *theMovie = [[IPaMoviePlayerController alloc] initWithContentOfFile:filePath endCallback:endCallback];
    [theMovie playInView:inView];
}

+ (void)playMovieWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                       inView:(UIView*)inView
                  endCallback:(void (^)(IPaMoviePlayerController*))endCallback
{

    IPaMoviePlayerController *theMovie = [[IPaMoviePlayerController alloc] initWithResource:SourceName
                                                                                     ofType:ofType endCallback:endCallback];
    [theMovie playInView:inView];
}

- (IPaMoviePlayerController*)initWithResource:(NSString*)SourceName ofType:(NSString*)ofType
{
    
    return  [self initWithURL:[[NSBundle mainBundle] URLForResource: SourceName
                                                             withExtension: ofType] endCallback:nil];
    
}
- (IPaMoviePlayerController*)initWithURL:(NSURL*)URL endCallback:(void (^)(IPaMoviePlayerController*))endCallback
{
    self = [super initWithContentURL:URL];
    
    self.shouldAutoplay = NO;
    self.scalingMode= MPMovieScalingModeAspectFill;      
    self.controlStyle= MPMovieControlStyleNone; //os 4.0    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //delegate = nil;
    
    //    endCallback = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlaybackStateChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onEndOfPlay:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onExitFullScreen:)
                                                 name:MPMoviePlayerDidExitFullscreenNotification
                                               object:self];
    EndCallback = [endCallback copy];
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IPaMoviePlayerController*)initWithContentOfFile:(NSString*)filePath endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
{
    return  [self initWithURL:[NSURL fileURLWithPath:filePath] endCallback:endCallback];
}
/*- (IPaMoviePlayerController*)initWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                                       target:(id)target EndCallback:(SEL)EndCallback*/
- (IPaMoviePlayerController*)initWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                                  endCallback:(void (^)(IPaMoviePlayerController*))endCallback
{
    self = [self initWithResource:SourceName ofType:ofType];
    
    EndCallback = [endCallback copy];
    return self;
}
- (void)sizeToFit
{
    if (self.view.superview != nil) {
        UIView *parentview = self.view.superview;
        [self closeMovie];
        [self showInView:parentview];
    }
}
- (void)playInView:(UIView*)view
{
    if(self.view.superview != nil)
    {
        return;
    }
    [self showInView:view];
    //    [self stop];
    [self play];
}

- (void)play{
    [IPaMoviePlayerController RetainPlayer:self];
   
    [super play];
    
}
-(void)stop {
    
    [super stop];
    [IPaMoviePlayerController ReleasePlayer:self];
}
- (void)showInView:(UIView*)view
{
    self.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [view addSubview: self.view]; 
}

- (void)closeMovie
{
    [self stop];
    
    if(self.view.superview != nil)
    {
        [self.view removeFromSuperview];
    }
}
- (void)setResource:(NSString*)SourceName ofType:(NSString*)ofType
{
    self.contentURL = [[NSBundle mainBundle] URLForResource: SourceName
                                              withExtension: ofType];
}
- (void)setContentFile:(NSString*)filePath
{
    self.contentURL = [NSURL fileURLWithPath:filePath];
}
@end
