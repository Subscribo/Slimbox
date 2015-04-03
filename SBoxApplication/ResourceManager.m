//
//  ResourceManager.m
//  SBoxApplication
//
//  Created by Gerhard Zeissl on 13.02.15.
//  Copyright (c) 2015 Zeissl e.U. All rights reserved.
//

#import "ResourceManager.h"
#import <AFNetworking/AFNetworking.h>
#import "ZipArchive.h"

#define BASE_URL @"http://nimeshneema.ninth.su/"

@interface ResourceManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) NSString *documentsDirectoryPath;
@property (nonatomic, strong) NSArray *ISOCountryCodesArray;

@end

@implementation ResourceManager
Singleton(ResourceManager)

- (instancetype)initSingleton {
	self = [super init];
	
	if (self) {
			// Initialise the class specific properties here.
		
			// Set the Docuemnts directory path.
		self.documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		
			// Initialize the country codes array:
			// FIXME: Remove the following snippet later.
		self.ISOCountryCodesArray = @[@"AD", @"BA", @"CA", @"DE", @"EC",
									  @"FI", @"GA", @"HK", @"ID", @"JE",
									  @"KE", @"LA", @"MA", @"NA", @"OM",
									  @"PA", @"QA", @"RE", @"SA", @"TC",
									  @"UA", @"US", @"VA", @"WF", @"YE",
									  @"ZA"];
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.geocoder = [[CLGeocoder alloc] init];
		
		self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
		
			// Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
		if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
			[self.locationManager requestWhenInUseAuthorization];
		}
		
		[self.locationManager startUpdatingLocation];
	}
	
	return self;
}

- (void)fetchBundle:(NSString *)bundleName {
	NSString *pathToFile = [self.documentsDirectoryPath stringByAppendingPathComponent:@"filename"];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	AFHTTPRequestOperation *operation = [manager GET:[NSString stringWithFormat:@"%@%@.zip",BASE_URL, bundleName]
								   parameters:nil
									  success:^(AFHTTPRequestOperation *operation, id responseObject) {
										  NSLog(@"successful download to %@", pathToFile);
										  
										  [self unzipBundle:bundleName];
									  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
										  NSLog(@"Error: %@", error);
									  }];
	operation.outputStream = [NSOutputStream outputStreamToFileAtPath:pathToFile append:NO];
}

- (void)unzipBundle:(NSString *)bundleName {
	ZipArchive *za = [[ZipArchive alloc] init];
	
	NSString *pathToFile = [self.documentsDirectoryPath stringByAppendingPathComponent:bundleName];
	NSArray *fileNameComponents = [bundleName componentsSeparatedByString:@"."];
 
	if([za UnzipOpenFile:pathToFile]) {
			// Output the file in Documents directory.
		if([za UnzipFileTo:[self.documentsDirectoryPath stringByAppendingPathComponent:fileNameComponents[2]] overWrite:YES] != NO ) {
				// Unzip data success.
				// Do something.
		} else {
				// Unzip failed.
				// Handle accordingly.
		}
		
		[za UnzipCloseFile];
	}
}

#pragma mark - CLLocationManager Delegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
		// Failed to get location.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
	CLLocation *newLocation = locations[0];
	
	if (newLocation != nil) {
			// Reverse Geocode from the determined co-ordinates to fetch placemarks
			// Reverse Geocoding, resolving the address.
		[self.geocoder reverseGeocodeLocation:newLocation
							completionHandler:^(NSArray *placemarks, NSError *error) {
			if (error == nil && [placemarks count] > 0) {
				self.placemark = [placemarks lastObject];
				
					// Use properties of CLPlacemark instance to retrive location info.
				NSLog(@"ISOcountryCode : %@", self.placemark.ISOcountryCode);
				NSLog(@"ZipCode : %@", self.placemark.postalCode);
				
					// In case of change of location, fetch the appropriate bundle from the back-end,
					// if it is not already available on device.
				
					// Check for presence of bundle file on device.
				NSString *filePath;
				NSString *fileName;
				
				if ([self.ISOCountryCodesArray indexOfObject:self.placemark.ISOcountryCode] != NSNotFound) {
					fileName = [NSString stringWithFormat:@"flags.bundle.%@.zip", self.placemark.ISOcountryCode];
					filePath = [NSString stringWithFormat:@"%@/flags.bundle.%@.zip", self.documentsDirectoryPath, self.placemark.ISOcountryCode];
				} else {
					fileName = @"flags.bundle.zip";
					filePath = [NSString stringWithFormat:@"%@/flags.bundle.zip", self.documentsDirectoryPath];
				}
				
				BOOL fileAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NULL];
				
				if (fileAlreadyExists == NO) {
						// Fetch the resource in background thread:
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
						AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
						AFHTTPRequestOperation *operation = [manager GET:[NSString stringWithFormat:@"%@%@", BASE_URL, fileName]
															  parameters:nil
																 success:^(AFHTTPRequestOperation *operation, id responseObject) {
																	 [self unzipBundle:fileName];
																 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
																	 NSLog(@"Error: %@", error);
																 }];
						operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
					});
				}
			} else {
				NSLog(@"%@", error.debugDescription);
			}
		}];
	} else {
			// Location not found. Handle accordingly.
	}
}

@end
