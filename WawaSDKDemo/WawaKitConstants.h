//
//  WawaKitConstants.h
//  WawaSDKDemo
//

#ifndef WawaKitConstants_h
#define WawaKitConstants_h

#define WwImageAServer          @"http://a.avatar.diaoyu-3.com"
#define WwImageIServer          @"http://a.img.diaoyu-3.com"
#define WwImageAttchmentServer  @"http://a.attach.diaoyu-3.com"

#define WwFileAttchment         @"http://a.attach.diaoyu-3.com"
#define WwImageAuthServer       @"http://a.img.diaoyu-3.com"

#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#endif /* WawaKitConstants_h */
