//
//  FreightOrder.h
//  LoadingPlan
//
//  Created by Ethan Zhang on 12/13/14.
//  Copyright (c) 2014 SAP SE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FreightOrder : NSObject

@property (nonatomic, retain) NSString * freightOrderID;
@property (nonatomic, retain) NSString * shipper;
@property (nonatomic, retain) NSString * consignee;
@property (nonatomic, retain) NSString * driver;
@property (nonatomic, retain) NSDate * pickupDatetime;
@property (nonatomic, retain) NSDate * deliveryDatetime;
@property (nonatomic, retain) NSString * deliveryAddress;
@property (nonatomic, retain) NSString * address;

@property (nonatomic, retain) NSMutableArray* foItems;

+ (NSArray *)allFreightOrders;
+ (FreightOrder *)freightOrderWithID: (NSString* )freightOrderID;

@end

@interface OrderItem : NSObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * itemType;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSString * unitOfMeasure;
@property (nonatomic, retain) NSString * major;
@property (nonatomic, retain) NSString * minor;
@property (nonatomic, readwrite) NSString *selected;

@end
