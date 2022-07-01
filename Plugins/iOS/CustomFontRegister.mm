#import <CoreText/CoreText.h>

@interface CustomFontRegister : NSObject
+ (CustomFontRegister *)getInstance;
- (void) startListener;
@end

@implementation CustomFontRegister

+ (CustomFontRegister *)getInstance {
  static CustomFontRegister *getInstance = nil;
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    getInstance = [[self alloc]init];
  });
  
  return getInstance;
}

-(void) startListener{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

-(void) applicationDidFinishLaunching : (NSNotification*) notif{
    NSLog(@"My applicationDidFinishLaunching");
    [self loadFontFromResourceBundle : @"Montserrat"];
    [self loadFontFromResourceBundle : @"BalooChettan2-Bold"];
}

- (void)registerIconFontWithURL:(NSURL *)url
{
#if !TARGET_OS_OSX
//    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
//    [UIFont familyNames];
//    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
//    CFErrorRef error;
//    CTFontManagerRegisterGraphicsFont(newFont, &error);
//    CFRelease(newFont);
//    CFRelease(fontDataProvider);
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    NSString *font = (__bridge NSString *)CGFontCopyPostScriptName(newFont);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(newFont, &error);
    CGFontRelease(newFont);
    
    NSLog(@"Registered font name : %@", font);
#endif
}

-(void *) loadFontFromResourceBundle : (NSString *) fontname
{
    NSBundle *resourceBundle = [self getAnalyticBundle];
    NSString *fontPath = [NSString stringWithFormat:@"Data/Raw/%@", fontname]; //Streaming Assets in Unity saves files at 'Data/Raw/<fontName>"
    NSURL *fontURL = [resourceBundle URLForResource:fontPath withExtension:@"ttf"];

//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self registerIconFontWithURL: fontURL];
//    });
    
    [self registerIconFontWithURL: fontURL];
}

-(NSBundle *) getAnalyticBundle;{
  NSBundle *bundle = [NSBundle mainBundle];
  return bundle;
}

@end

@class CustomFontRegister;
@interface UIApplication (Listener)

@end

@implementation UIApplication (Listener)

+(void) load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
        [[CustomFontRegister getInstance] startListener];
    });
    
    NSLog(@"OnAppDelegate Load!");
}

@end
