//
//  RequestPostUploadHelper.h
//  iTalk
//
//  Created by locky1218 on 15-4-4.
//  Copyright (c) 2015年 locky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestPostUploadHelper : NSObject

+ (NSString *)postRequestWithURL: (NSString *)url  // IN
                      postParems: (NSMutableDictionary *)postParems // IN 提交参数据集合
                     picFilePath: (NSString *)picFilePath  // IN 上传图片路径
                     picFileName: (NSString *)picFileName;  // IN 上传图片名称

/**
 * 修发图片大小
 */
+ (UIImage *) imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize) newSize;
/**
 * 保存图片
 */
+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
/**
 * 生成GUID
 */
+ (NSString *)generateUuidString;
@end
