#import "LMSAnnotationView.h"
#import "LMSAnnotation.h"

@implementation LMSAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        LMSAnnotation *lmsAnnotation = self.annotation;
        switch (lmsAnnotation.type) {
            case PVAttractionFirstAid:
                self.image = [UIImage imageNamed:@"firstaid"];
                break;
            case PVAttractionFood:
                self.image = [UIImage imageNamed:@"food"];
                break;
            case PVAttractionRide:
                self.image = [UIImage imageNamed:@"ride"];
                break;
            default:
                self.image = [UIImage imageNamed:@"lms"];
                break;
        }
    }
    
    return self;
}

@end