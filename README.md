IPaMoviePlayerController
========================

Block-base MPMoviePlayerController

you can easily use class method

+ (void)playMovieWithResource:(NSString*)SourceName ofType:(NSString*)ofType 
                       inView:(UIView*)inView
                  endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
+ (void)playMovieWithURL:(NSURL*)URL
                  inView:(UIView*)inView
             endCallback:(void (^)(IPaMoviePlayerController*))endCallback;
+ (void)playMovieWithContentOfFile:(NSString*)filePath
                  inView:(UIView*)inView
             endCallback:(void (^)(IPaMoviePlayerController*))endCallback;

to play a movie with  (if you use class method,you don't need to make [MPMoviePlayerController play],it will automatically to do that)

callback block has one parameter, it's the instance of IPaMoviePlayerController,you can use that instance to close movie