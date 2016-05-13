//
//  NHADApi.m
//  NHAutoTestPro
//
//  Created by hu jiaju on 16/5/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import "NHADApi.h"

#ifndef NH_AD_FLASH_TIMEINTERVAL
static const CGFloat NH_AD_FLASH_TIMEINTERVAL           = 2.5f;
#endif

@interface NHADApi ()

@property (nonatomic) CGFloat flashInterval;
@property (nonatomic) BOOL statusBarHiddenInited,adPrepared;
@property (nonatomic, strong, nullable) UIWindow *mainWin;
@property (nonatomic, strong) UIImageView *adBgImgV,*adImgV;
@property (nonatomic, copy) NHAdEvent touchEvent;

+ (instancetype)init;

- (void)resetFlashInterval:(CGFloat)flashInterval;

@end

static NHADApi * instance = nil;

@implementation NHADApi

+ (void)initialize {
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __initSetup];
    }
    return self;
}
/*
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self __setupInit];
//    }
//    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self __setupInit];
//    }
//    return self;
}
 */

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (void)loadView {
    
    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
    //hidden the stausBar
    [[UIApplication sharedApplication] setStatusBarHidden:true withAnimation:UIStatusBarAnimationFade];
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imgV];
    _adBgImgV = imgV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)__initSetup {
    
    self.flashInterval = NH_AD_FLASH_TIMEINTERVAL;
}

+ (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NHADApi alloc] init];
    });
    return instance;
}

+ (CGFloat)defaultFlashInterval {
    return [NHADApi init].flashInterval;
}

+ (void)setFlashInterval:(CGFloat)interval {
    if (interval < NH_AD_FLASH_TIMEINTERVAL) {
        interval = NH_AD_FLASH_TIMEINTERVAL;
    }
    [[NHADApi init] setFlashInterval:interval];
}

- (void)resetFlashInterval:(CGFloat)flashInterval {
    self.flashInterval = flashInterval;
}

#pragma mark -- 本地图片展示（针对已下载好的广告逻辑）

+ (void)showAd:(UIImage * _Nonnull)ad withEvent:(NHAdEvent _Nullable)event {
    NHADLocation location = {.type = NHADTypeUp, .scale = 1};
    [NHADApi showIn:nil withAd:ad withInfo:location withEvent:event];
}

+ (void)showAd:(UIImage * _Nonnull)ad withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event {
    [NHADApi showIn:nil withAd:ad withInfo:adinfo withEvent:event];
}

+ (void)showIn:(UIImage * _Nullable)bgImg withAd:(UIImage * _Nonnull)ad withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event {
    
    [[NHADApi init] adjustAdsDisplayInfo:adinfo];
    [[NHADApi init] showIn:bgImg withAd:ad withEvent:event];
}

#pragma mark -- 调整ADs imageview
- (void)adjustAdsDisplayInfo:(NHADLocation)adinfo {
    
    self.adPrepared = false;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    CGFloat m_scale = 0.75f;
    if (adinfo.scale <= 0 || adinfo.scale > 1) {
        adinfo.scale = m_scale;
    }
    CGFloat m_height = mainSize.height * adinfo.scale;
    CGFloat m_y = 0;
    if (adinfo.type == NHADTypeDown) {
        m_y = mainSize.height-m_height;
    }
    CGRect bounds = (CGRect){.origin = CGPointMake(0, m_y), .size = CGSizeMake(mainSize.width, m_height)};
    if (_adImgV == nil) {
        _adImgV = [[UIImageView alloc] init];
        [self.view addSubview:_adImgV];
    }
    self.adImgV.frame = bounds;
}

- (void)showIn:(UIImage *)bg withAd:(UIImage *)ad withEvent:(NHAdEvent)event {
    
    self.touchEvent = [event copy];
    self.adBgImgV.image = bg;
    self.adImgV.image = ad;
    
    UIWindow *mainWindow = self.mainWin;
    mainWindow.rootViewController = self;
    //mainWindow.layer.opacity = 0.01f;
    [mainWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.5 animations:^{
        //mainWindow.layer.opacity = 1.f;
    } completion:^(BOOL finished) {
        [[NHADApi init] setAdPrepared:true];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.flashInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });;
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.mainWin.layer.opacity = 0.01f;
        [[UIApplication sharedApplication] setStatusBarHidden:_statusBarHiddenInited withAnimation:UIStatusBarAnimationFade];
    } completion:^(BOOL finished) {
        if (finished) {
            self.adPrepared = false;
            [_mainWin removeFromSuperview];
            _mainWin = nil;
        }
    }];
}

#pragma mark -- Touch Action
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint m_point = [[touches anyObject] locationInView:self.view];
    CGRect bounds = self.adImgV.frame;
    if (CGRectContainsPoint(bounds, m_point) && _adPrepared && _mainWin) {
        if (_touchEvent) {
            _touchEvent();
        }
    }
}


#pragma mark -- getter
- (UIWindow *)mainWin {
    if (_mainWin == nil) {
        CGRect mainBounds = [UIScreen mainScreen].bounds;
        _mainWin = [[UIWindow alloc] initWithFrame:mainBounds];
        _mainWin.backgroundColor = [UIColor whiteColor];
        UIWindowLevel level = UIWindowLevelStatusBar + 10.f;
        if (_statusBarHiddenInited) {
            level = UIWindowLevelNormal + 10.f;
        }
        _mainWin.windowLevel = level;
    }
    return _mainWin;
}

#pragma mark -- 网络图片展示（针对需要联网显示的逻辑）

+ (void)showIn:(UIImage * _Nonnull)bgImg withAdLink:(NSString * _Nonnull)adlink withEvent:(NHAdEvent _Nullable)event {
    NHADLocation location = {.type = NHADTypeUp, .scale = 1};
    [NHADApi showIn:bgImg withAdLink:adlink withInfo:location withEvent:event];
}

+ (void)showIn:(UIImage * _Nonnull)bgImg withAdLink:(NSString * _Nonnull)adlink withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event {
    [[NHADApi init] adjustAdsDisplayInfo:adinfo];
    [[NHADApi init] showIn:bgImg withAdLink:adlink withEvent:event];
}

- (void)showIn:(UIImage *)bg withAdLink:(NSString *)adlink withEvent:(NHAdEvent)event {
    
    self.touchEvent = [event copy];
    self.adBgImgV.image = bg;
    //self.adImgV.image = ad;
    
    UIWindow *mainWindow = self.mainWin;
    mainWindow.rootViewController = self;
    //mainWindow.layer.opacity = 0.01f;
    [mainWindow makeKeyAndVisible];
    [UIView animateWithDuration:0.5 animations:^{
        //mainWindow.layer.opacity = 1.f;
    } completion:^(BOOL finished) {
        [[NHADApi init] setAdPrepared:true];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.flashInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
