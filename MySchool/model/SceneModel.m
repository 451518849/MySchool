//
//  SceneModel.m
//  MySchool
//
//  Created by apple on 16/2/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "SceneModel.h"

@implementation SceneModel

-(id)init
{
    _imagesArr = [[NSMutableArray alloc]init];
    _recommand = @"0";
    _latitude = @"";
    _longitude = @"";
    return self;
}

-(void)addSceneWithTitle:(NSString*)title
             andLocation:(NSString*)location
             andSendWord:(NSString*)sendWord
                 andTime:(NSString*)time
            andRecommand:(NSString*)recommand
            andImagesArr:(NSMutableArray*)imagesArr
{
    
    _title      = title;
    _time       = time;
    _location   = location;
    _sendWord   = sendWord;
    _recommand  = recommand;
    _imagesArr  = imagesArr;
}

- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_latitude forKey:@"latitude"];
    [aCoder encodeObject:_longitude forKey:@"longitude"];
    [aCoder encodeObject:_location forKey:@"location"];
    [aCoder encodeObject:_sendWord forKey:@"sendWord"];
    [aCoder encodeObject:_recommand forKey:@"recommand"];
    [aCoder encodeObject:_imagesArr forKey:@"imagesArr"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder; // NS_DESIGNATED_INITIALIZER
{
    self = [super init];
    if (self)
    {
        _title      = [aDecoder decodeObjectForKey:@"title"];
        _time       = [aDecoder decodeObjectForKey:@"time"];
        _latitude   = [aDecoder decodeObjectForKey:@"latitude"];
        _longitude  = [aDecoder decodeObjectForKey:@"longitude"];
        _location   = [aDecoder decodeObjectForKey:@"location"];
        _sendWord   = [aDecoder decodeObjectForKey:@"sendWord"];
        _recommand  = [aDecoder decodeObjectForKey:@"recommand"];
        _imagesArr  = [aDecoder decodeObjectForKey:@"imagesArr"];

    }
    return self;
}

@end
