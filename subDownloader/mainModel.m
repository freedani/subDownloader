//
//  mainModel.m
//  subDownloader
//
//  Created by 李达 on 2016/12/25.
//  Copyright © 2016年 李达. All rights reserved.
//

#import "mainModel.h"
#import <CommonCrypto/CommonDigest.h>

@implementation mainModel

- (void) sentRequestWithFilePath:(NSString*)filePath {
    NSString *filehash = [self getFileHashWithFilePath:filePath];
    NSString *pathinfo = filePath;
    NSString *format = @"json";
    NSString *lang = @"chn";
    [self sentRequestWithFileHash:filehash PathInfo:pathinfo Format:format Language:lang];
}

- (NSString*) getFileHashWithFilePath:(NSString*)filePath {
    NSMutableString *result = [[NSMutableString alloc] init];
    FILE *p_r= fopen([filePath cStringUsingEncoding:NSUTF8StringEncoding], "r");  //打开文件
    if (NULL == p_r)
    {
        NSLog(@"Open file error to read data !");
        return nil;
    }
    fseek(p_r, 0, SEEK_END);                //定位到文件末尾
    uint64_t dataLength = ftell(p_r);      //获取文件长度
    uint64_t position[4] = {4096, dataLength / 3, dataLength / 3 * 2,dataLength - 8192};
    for (NSInteger i = 0; i < 4 ; i++) {
        Byte buffer[4096];
        fseek(p_r, position[i], 0);                   //定位到文件起始位置
        fread(buffer, 4096, 1, p_r);                  //读取文件到指定的缓冲区
        unsigned char hashResult[CC_MD5_DIGEST_LENGTH];
        CC_MD5(buffer, 4096, hashResult);
        NSMutableString *hash = [NSMutableString string];
        for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [hash appendFormat:@"%02x", hashResult[i]];
        }
        if (i != 3) {
            [result appendFormat:@"%@;",hash];
        } else {
            [result appendFormat:@"%@",hash];
        }
    }
    fclose(p_r);
    return result;
}

- (void) downloadSubtitleWithArray:(NSArray *)array
                          fileName:(NSString *)filename
                              lang:(NSString *)lang {

    for (NSDictionary *object in array) {
        NSArray *filesArray = [object objectForKey:@"Files"];
        for (NSDictionary *files in filesArray) {
            NSString *ext = [files objectForKey:@"Ext"];
            NSString *link = [files objectForKey:@"Link"];
            NSURL* url = [NSURL URLWithString:link];
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                NSString *fileDirPath = [filename stringByDeletingLastPathComponent];
                NSString *suggestedFileName;
                NSString *suggestedFileNameWithoutExt = [response.suggestedFilename stringByDeletingPathExtension];
                NSString *suggestedFileNameWithoutExtAddLang = [suggestedFileNameWithoutExt stringByAppendingFormat:@".%@",lang];
                //遍历文件夹，查看是否有文件重名
                NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:fileDirPath];
                BOOL flag = true;
                NSInteger count = 0;
                while (flag) {
                    flag = false;
                    NSString *filepathAddCount = (count == 0 ? suggestedFileNameWithoutExtAddLang : [suggestedFileNameWithoutExtAddLang stringByAppendingFormat:@"%ld",count]);
                    for (NSString *otherFileInDir in directoryEnumerator) {
                        NSString *otherFileInDirWithoutExt = [otherFileInDir stringByDeletingPathExtension];
                        NSString *otherFileInDirExt = [otherFileInDir pathExtension];
                        if ([otherFileInDirExt isEqualToString:ext] && [otherFileInDirWithoutExt isEqualToString:filepathAddCount]) {
                            count++;
                            flag = true;
                            break;
                        }
                    }
                    suggestedFileName = [filepathAddCount stringByAppendingPathExtension:ext];
                }
                NSString *filepath = [fileDirPath stringByAppendingPathComponent:suggestedFileName];
                NSFileManager *mgr = [NSFileManager defaultManager];
                [mgr moveItemAtPath:location.path toPath:filepath error:nil];
            }];
            [downloadTask resume];
        }
    }
}

- (void) sentRequestWithFileHash:(NSString*)filehash
                        PathInfo:(NSString*)pathinfo
                        Format:(NSString*)format
                        Language:(NSString*)lang {
    NSString *urlString = @"https://www.shooter.cn/api/subapi.php";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:filehash forKey:@"filehash"];
    [dict setObject:pathinfo forKey:@"pathinfo"];
    [dict setObject:format forKey:@"format"];
    [dict setObject:lang forKey:@"lang"];
    AFHTTPSessionManager* manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager POST:urlString parameters:dict progress:nil success: ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
        [self downloadSubtitleWithArray:JSON fileName:pathinfo lang:lang];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error.description);
    }];

}

@end
