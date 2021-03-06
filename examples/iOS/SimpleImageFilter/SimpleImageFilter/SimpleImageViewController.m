#import "SimpleImageViewController.h"

@implementation SimpleImageViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadView
{    
    CGRect mainScreenFrame = [[UIScreen mainScreen] applicationFrame];	
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	self.view = primaryView;
    
    imageSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
    [imageSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
	imageSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    imageSlider.minimumValue = 0.0;
    imageSlider.maximumValue = 1.0;
    
    [primaryView addSubview:imageSlider];
    
    [self setupDisplayFiltering];
//    [self setupImageResampling];
//    [self setupImageFilteringToDisk];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageSlider.value = 0.5;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}


- (void)updateSliderValue:(id)sender
{
    CGFloat midpoint = [(UISlider *)sender value];
//    [(GPUImageTiltShiftFilter *)filter setTopFocusLevel:midpoint - 0.1];
//    [(GPUImageTiltShiftFilter *)filter setBottomFocusLevel:midpoint + 0.1];
    
//    midpoint = (midpoint * 10) - (1 - midpoint) * 10; //曝光度
//    [(GPUImageExposureFilter *)filter setExposure:midpoint];
//    midpoint = midpoint * 4.f;
//    [(GPUImageContrastFilter *)filter setContrast:midpoint];
//    midpoint = midpoint * 3.f;
//    [(GPUImageGammaFilter *)filter setGamma:midpoint];
//    midpoint = 4000 + (3 * midpoint) * 1000;
//    [(GPUImageWhiteBalanceFilter *)filter setTemperature:midpoint];
    
//    [(GPUImageHighlightShadowFilter *)filter setShadows:midpoint];
//    [(GPUImageHighlightShadowFilter *)filter setHighlights:midpoint];
//    midpoint = (midpoint * 3) - (1 - midpoint) * 3;
//    [(GPUImageHazeFilter *)filter setDistance:midpoint];
//    [(GPUImageHazeFilter *)filter setSlope:midpoint];
//    midpoint = midpoint * 4;
//    [(GPUImageAdaptiveThresholdFilter *)filter setBlurRadiusInPixels:midpoint];
//    [(GPUImageSolarizeFilter *)filter setThreshold:midpoint];
//    [(GPUImageAverageLuminanceThresholdFilter *)filter setThresholdMultiplier:midpoint];
//    [(GPUImageHistogramGenerator *)filter setThresholdMultiplier:midpoint];
//    [(GPUImageHighlightShadowFilter *)filter setShadows:midpoint];
    [(GPUImageLookupFilter *)filter setIntensity:midpoint];
    [sourcePicture processImage];
}

#pragma mark -
#pragma mark Image filtering

- (void)setupDisplayFiltering;
{
    UIImage *inputImage = [UIImage imageNamed:@"WID-small.jpg"]; // The WID.jpg example is greater than 2048 pixels tall, so it fails on older devices
    
    sourcePicture = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES];
//    filter = [[GPUImageTiltShiftFilter alloc] init];
//    filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//    GPUImageExposureFilter *filter = [[GPUImageExposureFilter alloc] init]; //曝光度
//    GPUImageContrastFilter *filter = [[GPUImageContrastFilter alloc] init]; //对比度
//    GPUImageSaturationFilter *filter = [[GPUImageSaturationFilter alloc] init]; //饱和度
//    GPUImageGammaFilter *filter = [[GPUImageGammaFilter alloc] init]; //饱和度
//    GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc] init]; //白平衡
//    GPUImageHighlightShadowFilter *filter = [[GPUImageHighlightShadowFilter alloc] init];
//    GPUImageHazeFilter *filter = [[GPUImageHazeFilter alloc] init];
//    GPUImageSepiaFilter *filter = [[GPUImageSepiaFilter alloc] init];             //褐色
//    GPUImageColorInvertFilter *filter = [[GPUImageColorInvertFilter alloc] init]; //反色
//    GPUImageGrayscaleFilter *filter = [[GPUImageGrayscaleFilter alloc] init]; //灰度
//    GPUImageLuminanceThresholdFilter *targetFilter = [[GPUImageLuminanceThresholdFilter alloc] init]; //亮度
//    GPUImageAdaptiveThresholdFilter *targetFilter = [[GPUImageAdaptiveThresholdFilter alloc] init]; //亮度
//    GPUImageSolarizeFilter *targetFilter = [[GPUImageSolarizeFilter alloc] init]; //曝光
//    GPUImageAverageLuminanceThresholdFilter *targetFilter = [[GPUImageAverageLuminanceThresholdFilter alloc] init]; //曝光
//    GPUImageHistogramFilter* targetFilter = [[GPUImageHistogramFilter alloc] initWithHistogramType:kGPUImageHistogramRed];
//    GPUImageHistogramGenerator *targetFilter = [[GPUImageHistogramGenerator alloc] init]; //柱状图
//    GPUImageHistogramGenerator *targetFilter = [[GPUImageHistogramGenerator alloc] init];
    GPUImageLookupFilter *targetFilter = [[GPUImageLookupFilter alloc] init];
    filter = targetFilter;
    
    
    GPUImageView *imageView = (GPUImageView *)self.view;
    [filter forceProcessingAtSize:imageView.sizeInPixels]; // This is now needed to make the filter run at the smaller output size
    [filter addTarget:imageView];
    

    [sourcePicture addTarget:filter];
    [sourcePicture processImage];
}

- (void)setupImageFilteringToDisk;
{
    // Set up a manual image filtering chain
    NSURL *inputImageURL = [[NSBundle mainBundle] URLForResource:@"Lambeau" withExtension:@"jpg"];

//    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    NSLog(@"First image filtering");
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithURL:inputImageURL];

    GPUImageSepiaFilter *stillImageFilter = [[GPUImageSepiaFilter alloc] init];
    GPUImageVignetteFilter *vignetteImageFilter = [[GPUImageVignetteFilter alloc] init]; //光晕图
    vignetteImageFilter.vignetteEnd = 0.6;
    vignetteImageFilter.vignetteStart = 0.4;
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter addTarget:vignetteImageFilter];

    [vignetteImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];

    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    @autoreleasepool {
        UIImage *currentFilteredImage = [vignetteImageFilter imageFromCurrentFramebuffer];
        
        NSData *dataForPNGFile = UIImagePNGRepresentation(currentFilteredImage);
        if (![dataForPNGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-filtered1.png"] options:NSAtomicWrite error:&error])
        {
            NSLog(@"Error: Couldn't save image 1");
        }
        dataForPNGFile = nil;
        currentFilteredImage = nil;
    }
    
    // Do a simpler image filtering
//    GPUImageSketchFilter *stillImageFilter2 = [[GPUImageSketchFilter alloc] init];
//    GPUImageSobelEdgeDetectionFilter *stillImageFilter2 = [[GPUImageSobelEdgeDetectionFilter alloc] init];
//    GPUImageAmatorkaFilter *stillImageFilter2 = [[GPUImageAmatorkaFilter alloc] init];
//    GPUImageUnsharpMaskFilter *stillImageFilter2 = [[GPUImageUnsharpMaskFilter alloc] init];
    GPUImageSepiaFilter *stillImageFilter2 = [[GPUImageSepiaFilter alloc] init];
    NSLog(@"Second image filtering");
    UIImage *inputImage = [UIImage imageNamed:@"Lambeau.jpg"];
    UIImage *quickFilteredImage = [stillImageFilter2 imageByFilteringImage:inputImage];
    
    // Write images to disk, as proof
    NSData *dataForPNGFile2 = UIImagePNGRepresentation(quickFilteredImage);
    
    if (![dataForPNGFile2 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-filtered2.png"] options:NSAtomicWrite error:&error])
    {
        NSLog(@"Error: Couldn't save image 2");
    }
}

- (void)setupImageResampling;
{
    UIImage *inputImage = [UIImage imageNamed:@"Lambeau.jpg"];
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    
    // Linear downsampling
    GPUImageBrightnessFilter *passthroughFilter = [[GPUImageBrightnessFilter alloc] init];
    [passthroughFilter forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [passthroughFilter useNextFrameForImageCapture];
    [stillImageSource addTarget:passthroughFilter];
    [stillImageSource processImage];
    UIImage *nearestNeighborImage = [passthroughFilter imageFromCurrentFramebuffer];

    [stillImageSource removeAllTargets]; //clean up filter
    // Lanczos downsampling
    GPUImageLanczosResamplingFilter *lanczosResamplingFilter = [[GPUImageLanczosResamplingFilter alloc] init];
    [lanczosResamplingFilter forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [stillImageSource addTarget:lanczosResamplingFilter];
    [lanczosResamplingFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    UIImage *lanczosImage = [lanczosResamplingFilter imageFromCurrentFramebuffer];
    
    // Trilinear downsampling
    GPUImagePicture *stillImageSource2 = [[GPUImagePicture alloc] initWithImage:inputImage smoothlyScaleOutput:YES]; //smoothly
    GPUImageBrightnessFilter *passthroughFilter2 = [[GPUImageBrightnessFilter alloc] init];
    [passthroughFilter2 forceProcessingAtSize:CGSizeMake(640.0, 480.0)];
    [stillImageSource2 addTarget:passthroughFilter2];
    [passthroughFilter2 useNextFrameForImageCapture];
    [stillImageSource2 processImage];
    UIImage *trilinearImage = [passthroughFilter2 imageFromCurrentFramebuffer];

    NSData *dataForPNGFile1 = UIImagePNGRepresentation(nearestNeighborImage);
    NSData *dataForPNGFile2 = UIImagePNGRepresentation(lanczosImage);
    NSData *dataForPNGFile3 = UIImagePNGRepresentation(trilinearImage);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSError *error = nil;
    if (![dataForPNGFile1 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-NN.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }

    if (![dataForPNGFile2 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-Lanczos.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }

    if (![dataForPNGFile3 writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Lambeau-Resized-Trilinear.png"] options:NSAtomicWrite error:&error])
    {
        return;
    }
}

@end
