//
//  FreightOrder.m
//  LoadingPlan
//
//  Created by Ethan Zhang on 12/13/14.
//  Copyright (c) 2014 SAP SE. All rights reserved.
//

#import "FreightOrder.h"


@implementation FreightOrder

+ (NSArray *)allFreightOrders{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"FreightOrders" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    
    NSArray *freightOrderArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *freightOrders = [[NSMutableArray alloc] initWithCapacity:freightOrderArray.count];
    FreightOrder *freightOrder = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyyMMddHHmmss";
    
    
    for (id foEntry in freightOrderArray) {
        
        freightOrder = [[FreightOrder alloc] init];
        freightOrder.freightOrderID =  [foEntry valueForKey:@"freightOrderID"];
        freightOrder.shipper = [foEntry valueForKey:@"shipper"];
        freightOrder.consignee = [foEntry valueForKey:@"consignee"];
        freightOrder.driver = [foEntry valueForKey:@"driver"];
        freightOrder.pickupDatetime = [dateFormatter dateFromString:[foEntry valueForKey:@"pickupDatetime"]];
        freightOrder.deliveryDatetime = [dateFormatter dateFromString:[foEntry valueForKey:@"deliveryDatetime"]];
        freightOrder.deliveryAddress = [foEntry valueForKey:@"deliveryAddress"];
        freightOrder.address = [foEntry valueForKey:@"address"];
        
        
        NSArray *items = [foEntry valueForKey:@"items"];
        freightOrder.foItems = [NSMutableArray arrayWithCapacity:items.count];
        OrderItem *orderItem = nil;
        for (id item in items) {
            orderItem = [[OrderItem alloc] init];
            orderItem.itemName = [item valueForKey:@"itemName"];
            orderItem.itemType = [item valueForKey:@"itemType"];
            orderItem.quantity = [item valueForKey:@"quantity"];
            orderItem.unitOfMeasure = [item valueForKey:@"unitOfMeasure"];
            orderItem.major = [item valueForKey:@"major"];
            orderItem.minor = [item valueForKey:@"minor"];
            orderItem.selected=@"unselected";
            [freightOrder.foItems addObject:orderItem];
        }
        
        [freightOrders addObject:freightOrder];
    }
    
    return freightOrders;
}

+ (FreightOrder *)freightOrderWithID:(NSString *)freightOrderID{
    FreightOrder *foundFreightOrder = nil;
    
    NSArray *freightOrders = [self allFreightOrders];
    
    for (FreightOrder *freightOrder in freightOrders) {
        if ([freightOrder.freightOrderID isEqualToString:freightOrderID]) {
            foundFreightOrder = freightOrder;
            break;
        }
    }
    
    return foundFreightOrder;
}

@end
@implementation OrderItem

@end
