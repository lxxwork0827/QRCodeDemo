//
//  ViewController.m
//  二维码Demo
//
//  Created by 刘星星 on 16/10/14.
//  Copyright © 2016年 刘星星. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImageView * logoImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test2];
    [self test3];
}
- (void)test1 {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认设置
    [filter setDefaults];
    //给过滤器添加数据
    //    NSString *str = @"深圳掌康科技有限公司";
    NSString *str = @"http://music.163.com/#/m/song?id=28838178";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //输出二维码
    CIImage *outputImage = [filter outputImage];
//    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(7, 7)];
//    self.imageView.image = [UIImage imageWithCIImage:outputImage];
    self.imageView.image = [self createNonInterpolatedUIImageWithCIImage:outputImage withSize:200];
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    self.imageView.layer.shadowOffset=CGSizeMake(0, 2);//设置阴影的偏移量
    self.imageView.layer.shadowRadius=1;//设置阴影的半径
    self.imageView.layer.shadowColor=[UIColor redColor].CGColor;//设置阴影的颜色为红色
    self.imageView.layer.shadowOpacity=0.7;
}
- (UIImage *)createNonInterpolatedUIImageWithCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    NSLog(@"-------%@",NSStringFromCGRect(extent));//{{0, 0}, {27, 27}}
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
#pragma mark - test2
- (void)test2 {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *str = @"http://music.163.com/#/m/song?id=28838178";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setDefaults];
    /*
     inputImage,   //输入的图片
     inputColor0,  //前景色
     inputColor1   //背景色
     */
    [colorFilter setValue:outputImage forKey:@"inputImage"];
    //需要使用 CIColor
    [colorFilter setValue:[CIColor colorWithCGColor:[UIColor blackColor].CGColor] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithCGColor:[UIColor orangeColor].CGColor] forKey:@"inputColor1"];
    //设置输出
    CIImage *colorImage = [colorFilter outputImage];
    colorImage = [colorImage imageByApplyingTransform:CGAffineTransformMakeScale(7, 7)];
    self.imageView.image = [UIImage imageWithCIImage:colorImage];
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    self.imageView.layer.shadowOffset=CGSizeMake(0, 2);//设置阴影的偏移量
    self.imageView.layer.shadowRadius=1;//设置阴影的半径
    self.imageView.layer.shadowColor=[UIColor redColor].CGColor;//设置阴影的颜色为红色
    self.imageView.layer.shadowOpacity=0.7;
    
}
- (void)test3 {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复默认设置
    [filter setDefaults];
    //给过滤器添加数据
    //    NSString *str = @"深圳掌康科技有限公司";
    NSString *str = @"http://music.163.com/#/m/song?id=28838178";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    //输出二维码
    CIImage *outputImage = [filter outputImage];
    //    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(7, 7)];
    //    self.imageView.image = [UIImage imageWithCIImage:outputImage];
    self.logoImageView.image = [self createNonInterpolatedUIImageWithCIImage:outputImage withSize:200];
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(self.logoImageView.image.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [self.logoImageView.image drawInRect:CGRectMake(0, 0, self.logoImageView.image.size.width, self.logoImageView.image.size.height)];
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@"1@2x.jpg"];
    CGFloat sImageW = 50;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (self.logoImageView.image.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (self.logoImageView.image.size.height - sImageH) * 0.5;
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    //设置图片
    self.logoImageView.image = finalyImage;
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    self.logoImageView.layer.shadowOffset=CGSizeMake(0, 2);//设置阴影的偏移量
    self.logoImageView.layer.shadowRadius=1;//设置阴影的半径
    self.logoImageView.layer.shadowColor=[UIColor redColor].CGColor;//设置阴影的颜色为红色
    self.logoImageView.layer.shadowOpacity=0.7;
    
}
//logo视图
-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 20, 200, 200)];
        [self.view addSubview:_logoImageView];
    }
    return _logoImageView;
}
@end
