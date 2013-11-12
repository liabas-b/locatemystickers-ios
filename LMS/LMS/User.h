//
//  User.h
//  LMS
//
//  Created by Adrien Guffens on 11/11/13.
//  Copyright (c) 2013 Team3000. All rights reserved.
//

#import "JSONModel.h"

@protocol User
@end

@interface User : JSONModel

@property (assign, nonatomic) int id;
//@property (assign, nonatomic) bool *admin;
@property (strong, nonatomic) NSString *adress;
@property (strong, nonatomic) NSString *city;
@property (assign, nonatomic) int compteur;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *passwordDigest;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *rememberToken;
@property (strong, nonatomic) NSString *updatedAt;
@property (strong, nonatomic) NSString *zipCode;

@end
