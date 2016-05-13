//
//  NHADApi.h
//  NHAutoTestPro
//
//  Created by hu jiaju on 16/5/13.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NHADTypeUp              = 1 << 0,
    NHADTypeDown            = 1 << 1
}NHADType;

typedef NHADType NHADType;

struct NHADLocation {
    NHADType    type;
    CGFloat     scale;
};

typedef struct NHADLocation NHADLocation;

typedef void(^NHAdEvent)(void);

NS_ASSUME_NONNULL_BEGIN

@interface NHADApi : UIViewController

/**
 *  @brief time interval for default flash
 *
 *  @return the interval
 */
+ (CGFloat)defaultFlashInterval;

/**
 *  @brief reset the flash interval
 *
 *  @param interval must be positive!
 */
+ (void)setFlashInterval:(CGFloat)interval;


#pragma mark -- 本地图片展示（针对已下载好的广告逻辑）
/**
 *  @brief <#Description#>
 *
 *  @param ad    <#ad description#>
 *  @param event <#event description#>
 */
+ (void)showAd:(UIImage * _Nonnull)ad withEvent:(NHAdEvent _Nullable)event;

+ (void)showAd:(UIImage * _Nonnull)ad withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event;

+ (void)showIn:(UIImage * _Nullable)bgImg withAd:(UIImage * _Nonnull)ad withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event;

#pragma mark -- 网络图片展示（针对需要联网显示的逻辑）
/**
 *  @brief 此种情况下,网速不好时，flash时间内如果没有下载完毕则会跳过,需要提供一张背景图
 *  SDWebImage.framework needed!
 */
+ (void)showIn:(UIImage * _Nonnull)bgImg withAdLink:(NSString * _Nonnull)adlink withEvent:(NHAdEvent _Nullable)event;

+ (void)showIn:(UIImage * _Nonnull)bgImg withAdLink:(NSString * _Nonnull)adlink withInfo:(NHADLocation)adinfo withEvent:(NHAdEvent _Nullable)event;

NS_ASSUME_NONNULL_END

@end