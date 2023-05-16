//
//  IAPHelper.m
//  TPAPReceiptLocally
//
//  Created by Thang Phung on 26/05/2021.
//

#import "TPIAPHelper.h"
#import "OpenSSL.h"

@implementation TPIAPHelper

+ (nullable NSNumber*)readASN1Integer:(const uint8_t **)p andMaxLength:(long)maxLength {
    int type = 0;
    int xclass = 0;
    long length = 0;
    
    const uint8_t *save_ptr = *p;
    ASN1_get_object(&save_ptr, &length, &type, &xclass, maxLength);
    if (type != V_ASN1_INTEGER) {
        return NULL;
    }
    
    ASN1_INTEGER *integerObject = d2i_ASN1_UINTEGER(NULL, p, maxLength);
    long intValue = ASN1_INTEGER_get(integerObject);
    ASN1_INTEGER_free(integerObject);
    p += length;
    return [NSNumber numberWithLong:intValue];
}

+ (nullable NSString*)readASN1String:(const uint8_t **)p andMaxLength:(long)maxLength {
    int strClass = 0;
    int strType = 0;
    long strLength = 0;
    
    const uint8_t **save_ptr = p;
    ASN1_get_object(save_ptr, &strLength, &strType, &strClass, maxLength);
    if (strType == V_ASN1_UTF8STRING) {
        return [[NSString alloc] initWithBytes:*save_ptr length:strLength encoding:NSUTF8StringEncoding];
    }
    
    if (strType == V_ASN1_IA5STRING) {
        return [[NSString alloc] initWithBytes:*save_ptr length:strLength encoding:NSASCIIStringEncoding];
    }
    
    p += maxLength;
    return NULL;
}

+ (nullable NSData*)readASN1Data:(const uint8_t **)p andMaxLength:(long)maxLength {
    return [[NSData alloc] initWithBytes:*p length:maxLength];
}

+ (nullable NSDate*)readASN1Date:(const uint8_t **)p andMaxLength:(long)maxLength {
    int strClass = 0;
    int strType = 0;
    long strLength = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    const uint8_t **strPointer = p;
    ASN1_get_object(strPointer, &strLength, &strType, &strClass, maxLength);
    if (strType != V_ASN1_IA5STRING) {
        return NULL;
    }
    
    NSString *dateString = [[NSString alloc] initWithBytes:*strPointer length:strLength encoding:NSASCIIStringEncoding];
    if (dateString != NULL) {
        return [formatter dateFromString:dateString];
    }
    
    return NULL;
}

@end
