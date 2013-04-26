#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    PVAttractionDefault = 0,
    PVAttractionRide,
    PVAttractionFood,
    PVAttractionFirstAid
} LMSType;

@interface LMSAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) LMSType type;

@end