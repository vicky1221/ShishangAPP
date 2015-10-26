//
//  Account.h
//  ShiShangLife
//
//  Created by vickycao1221 on 10/26/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Jastor.h"

@interface Account : Jastor

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *City;
@property (nonatomic, strong) NSString *Area;
@property (nonatomic, strong) NSString *No;
@property (nonatomic, strong) NSString *Summary;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *login_time;


@end
