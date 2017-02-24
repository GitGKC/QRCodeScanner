//
//  GetImageBright.h
//  111111
//
//  Created by 公安信息 on 16/5/30.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 这个类是求出图片亮度的
@interface GetImageBright : NSObject
// 获取图片数据RGB数据，存放在一个指针指向的内存空间中
- (unsigned char *)getImageData:(UIImage*)image;
// 获取图片亮度
- (int)getBrightWithImagedata:(unsigned char *)imagedata WithImageSize:(CGSize)size;
// 综合方法1和2:直接根据图片获取亮度
- (int)getBrightWithImage:(UIImage*)image;
// 获取灰度值(亮度值)：获取以point为起点，size尺寸大小的区域灰度值
- (int)getBrightWithImage:(UIImage*)image WithImageSize:(CGSize)size WithOrigin:(CGPoint)point;
@end
