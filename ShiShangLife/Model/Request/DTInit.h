//
//  DTInit.h
//  forum

#define CLIENT_VERSION  1


#ifndef kaoyan_DTInit_h
#define kaoyan_DTInit_h

//model层缓存时间
#define URL_CACHE_LIFE_TIME  3600

//系统整体默认色
#define UIBGCOLOR_245   [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0]
#define UITEXTCOLOR_153 [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define UITEXTCOLOR_170 [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0]
#define UILINECOLOR_220 [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]

//rgb颜色
#define rgb_color(r , g , b , a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

// rgb颜色
#define DTRGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

//手机号码验证
#define isPhoneNumber @"^1((3[0-9])|(5[0|1|2|3|5|6|7|8|9])|(8[0-9])|(4[5|7]))\\d{8}$"

//身份证验证
#define isCardID @"/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$/"

//邮编
#define iszipNumber @"[1-9]\\d{5}(?!\\d)"

//检测是否为空
#define DTIsNull(id) [id isEqual:[NSNull null]]

#define DT_RANDOM_0_1() ((random() / (float)0x7fffffff ))

#endif


