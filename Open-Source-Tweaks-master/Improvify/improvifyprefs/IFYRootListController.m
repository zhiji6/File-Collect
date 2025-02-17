#include "IFYRootListController.h"
#import "IFYCustomHeaderClassCell.h"
#import "PreferencesColorDefinitions.h"
#import "libcolorpicker.h"

@implementation IFYRootListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
		}
		return _specifiers;
	}

	-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return (UIView *)[[IFYCustomHeaderCell alloc] init];
		}
    return nil;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		if (section == 0) {
			return 170.0f;
		}
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)killSpotify {
		UIAlertController *killSpotifyAlert = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"Are you sure you want to restart Spotify?" preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Kill" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.lacertosusrepo.improvifyprefs-killSpotify"), nil, nil, true);
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[killSpotifyAlert addAction:confirmAction];
		[killSpotifyAlert addAction:cancelAction];
		[self presentViewController:killSpotifyAlert animated:YES completion:nil];
	}

	-(void)resetSpotifyPlayHistory {
		UIAlertController *resetSpotifyHistoryAlert = [UIAlertController alertControllerWithTitle:@"Improvify" message:@"Are you sure you want to reset your play history? You cannot recover it after deletion.\n\n Spotify must be running for this to work." preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
			NSMutableDictionary *improvifydata = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist"];
		  [improvifydata removeObjectForKey:@"songHistory"];
		  [improvifydata writeToFile:@"/User/Library/Preferences/com.lacertosusrepo.improvifydata.plist" atomically:YES];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
		[resetSpotifyHistoryAlert addAction:confirmAction];
		[resetSpotifyHistoryAlert addAction:cancelAction];
		[self presentViewController:resetSpotifyHistoryAlert animated:YES completion:nil];
	}

	-(void)twitter {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/LacertosusDeus"] options:@{} completionHandler:nil];
	}

	-(void)paypal {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lacertosusrepo.github.io/depictions/resources/donate.html"] options:@{} completionHandler:nil];
	}

	-(void)github {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

@end

@implementation ImprovifyPlaylistsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImprovifyPlaylists" target:self] retain];
		}
		return _specifiers;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation ImprovifyQuickAddSettingsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImprovifyQuickAddSettings" target:self] retain];
		}
		return _specifiers;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation ImprovifyQuickDeleteSettingsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImprovifyQuickDeleteSettings" target:self] retain];
		}
		return _specifiers;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation ImprovifySongCountSettingsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImprovifySongCountSettings" target:self] retain];
		}
		return _specifiers;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

	-(void)_returnKeyPressed:(id)arg1 {
		[self.view endEditing:YES];
	}

@end

@implementation ImprovifyMiscellaneousSettingsListController

	-(NSArray *)specifiers {
		if (!_specifiers) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"ImprovifyMiscellaneousSettings" target:self] retain];
		}
		return _specifiers;
	}

	-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		return (CGFloat)-1;
	}

	-(void)viewDidLoad {
		//Adds GitHub button in top right of preference pane
		UIImage *iconBar = [[UIImage alloc] initWithContentsOfFile:@"/Library/PreferenceBundles/improvifyprefs.bundle/barbutton.png"];
		iconBar = [iconBar imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIBarButtonItem *webButton = [[UIBarButtonItem alloc] initWithImage:iconBar style:UIBarButtonItemStylePlain target:self action:@selector(webButtonAction)];
		self.navigationItem.rightBarButtonItem = webButton;

		[webButton release];
		[super viewDidLoad];
	}

	-(IBAction)webButtonAction {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://github.com/LacertosusRepo"] options:@{} completionHandler:nil];
	}

	-(void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
			//Changed colors of Navigation Bar, Navigation Text
		self.navigationController.navigationController.navigationBar.tintColor = Sec_Color;
		self.navigationController.navigationController.navigationBar.barTintColor = Main_Color;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
		self.navigationController.navigationController.navigationBar.translucent = NO;
			//Changes colors of Slider Filler, Switches when enabled, Segment Switches, iOS 10+ friendly
		[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
		[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].onTintColor = Switch_Color;
		[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor = Switch_Color;
	}

	-(void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
				//Returns normal colors to Navigation Bar
		self.navigationController.navigationController.navigationBar.tintColor = nil;
		self.navigationController.navigationController.navigationBar.barTintColor = nil;
		self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;
		self.navigationController.navigationController.navigationBar.translucent = YES;
	}

	//https://github.com/angelXwind/KarenPrefs/blob/master/KarenPrefsListController.m
	-(id)readPreferenceValue:(PSSpecifier*)specifier {
		NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		if (![prefs objectForKey:[specifier.properties objectForKey:@"key"]]) {
			return [specifier.properties objectForKey:@"default"];
		}
		return [prefs objectForKey:[specifier.properties objectForKey:@"key"]];
	}

	-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
		NSMutableDictionary * prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]]];
		[prefs setObject:value forKey:[specifier.properties objectForKey:@"key"]];
		[prefs writeToFile:[NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", [specifier.properties objectForKey:@"defaults"]] atomically:YES];
		if([specifier.properties objectForKey:@"PostNotification"]) {
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), (CFStringRef)[specifier.properties objectForKey:@"PostNotification"], NULL, NULL, YES);
		}
		[super setPreferenceValue:value specifier:specifier];
	}

@end
