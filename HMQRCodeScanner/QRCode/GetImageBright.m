//
//  GetImageBright.m
//  111111
//
//  Created by 公安信息 on 16/5/30.
//  Copyright © 2016年 zyx. All rights reserved.
//

#import "GetImageBright.h"
#import <UIKit/UIKit.h>

@interface GetImageBright()
// 声明属性用于存放图片的尺寸
// 宽
@property (nonatomic, assign) int width;
// 高
@property (nonatomic, assign) int height;

@end


@implementation GetImageBright

- (unsigned char *)getImageData:(UIImage*)image
{
    // 1、此函数是将UIImage的像素点保存在 unsigned char * 里面，不能直观的用.x或者.y读取，可以转换下
    CGImageRef imageref = [image CGImage];
    
    // 2、创建一个devicergb颜色空间 // bitmap上下文使用的颜色空间。
    CGColorSpaceRef colorspace=CGColorSpaceCreateDeviceRGB();
    
    // 3、获取到图片本身的大小，宽度，单位是像素（不是imageview的大小）
    int width=CGImageGetWidth(imageref); // bitmap的宽度,单位为像素
    int height=CGImageGetHeight(imageref); // bitmap的高度,单位为像素
    
    self.width = width;
    self.height = height;
    
    // 4、设置参数
    int bytesPerPixel = 4;
    int bytesPerRow=bytesPerPixel*width; // bitmap的每一行在内存所占的比特数
    int bitsPerComponent = 8;// 内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
    
    // 5、分配存储空间——指向要渲染的绘制内存的地址 imagedata 是个指针，指向大小为width*height*bytesPerPixel的内存空间
    unsigned char * imagedata=malloc(width*height*bytesPerPixel);
    // 6、返回一张复制后的快照图片——根据the bitmap context `context'
    CGContextRef cgcnt = CGBitmapContextCreate(imagedata,width,height,bitsPerComponent,bytesPerRow,colorspace,kCGImageAlphaPremultipliedFirst);
    
    // 7、将图像写入一个矩形
    CGRect therect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(cgcnt, therect, imageref);
    
    
    //    释放资源
    CGColorSpaceRelease(colorspace);
    CGContextRelease(cgcnt);
    
    
    //    [ARGB release];
    return imagedata;
    
}


- (int)getBrightWithImagedata:(unsigned char *)imagedata WithImageSize:(CGSize)size
{
    
    int num = 1;
    double bright = 0;
    int r;
    int g;
    int b;
    for (int i = 0; i < 4 * size.width * size.height; i++) {
        if (i%4 == 0) {
            num++;
            r = imagedata[i+1];
            g = imagedata[i+2];
            b = imagedata[i+3];
            bright = bright + 0.299 * r + 0.587 * g + 0.114 * b;
        }
    }
    free(imagedata);
    bright = (int) (bright / num);
    return bright;
    
}

- (int)getBrightWithImage:(UIImage*)image
{
    unsigned char * imagedata = [self getImageData:image];
    int bright = [self getBrightWithImagedata:imagedata WithImageSize:CGSizeMake(_width, _height)];
    return bright;
    
}

// 获取灰度值(亮度值)：获取以point为起点，size尺寸大小的区域灰度值
// image：图片
// size: 获取区域的尺寸
// point：获取区域的起点
- (int)getBrightWithImage:(UIImage*)image WithImageSize:(CGSize)size WithOrigin:(CGPoint)point
{
    
    CGImageRef ref = [image CGImage];
    
    int width = (int)CGImageGetWidth(ref);
    int height = (int)CGImageGetHeight(ref);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel *width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * oldPixels;
    oldPixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace =     CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(oldPixels, width, height,     bitsPerComponent, bytesPerRow, colorSpace,     kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //    NSLog(@"%ld",oldPixels);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), ref);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    
    int lTotalGray = 0;
    
    
    for (int h = 0; h < height; h++) {
        for (int w = 0; w <width; w++) {
            
            int color = oldPixels[h*width + w];
            
            int r = (color >> 16) & 0xFF;
            int g = (color >> 8) & 0xFF;
            int b = color & 0xFF;
            int gray = (int)(r * 0.3 + g * 0.59 + b * 0.11);
            
            //            NSLog(@"%d",color);
            if (h > point.y && h < point.y + size.height) {
                //                                printf("%d-%d-%d\n",r,g,b);
                if (w > point.x && w < point.x + size.width) {
                    
                    lTotalGray += gray;
                    //                    NSLog(@"%d",lTotalGray);
                    
                }
            }
            
        }
    }
    
    
    
    UIGraphicsEndImageContext();
    
    free(oldPixels);
    float lAveGray = lTotalGray/(size.width*size.height);
    return lAveGray;
    
}
@end
