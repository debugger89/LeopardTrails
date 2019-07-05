# LeopardTrails
LeopardTrails is an iOS application which targets to identify the of leopards in Srilanka. 

### Why This was Required?

> “During the last two decades, identification of individual animals has been widely recognised as a vital component of modern wildlife research. Individual identification provides a non-invasive, simple, and inexpensive means of following animal movements and behaviour. This, over a period of time, provides information of the area or home range the animal uses, and in turn, assists wildlife researchers to determine the area required by the species for its survival. Individual identification studies also provide an insight to individual animal behaviour, which can be distinctly different from the accepted and known behaviour of the species as a whole. These studies also provide a range of other important data such as, the spacing of litters, age of cub dispersal, and lifespan in the wild.”
> - Late Dr. Ravi Samarasinha (One of the leading naturalists in SriLanka)

When a naturalist needs to identify a leopard spotted in a national park, the means of identificating the leopard is based on the experiance and the guessworks which may lead to invalid conclusions.

### Credits
This application is reusing on the carefully indexed information in the [wilpattu.com](https://www.wilpattu.com) and [Yala Leopard Diary Facebook group](https://www.facebook.com/groups/129638654392324/photos/?filter=albums). So the credits should go to the contributors of each source.

### Screenshots

<table style="width:100%">
  <tr>
    <td>
        <img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/camera%20view.png" width="300">
    </td>
    <td>
        <img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/crop%20selected%20image.png" width="300">
    </td> 
    <td>
      <img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/identify%20view.png" width="300">
    </td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/settings%20view.png" width="300">
    </td>
    <td>
      <img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/results%20view.png" width="300">
    </td>
  </tr>
</table>


### Approach

One of the most common ways to identify a leopard is to match the spot patterns in the face. (between eyes and ears)

<img src="https://github.com/debugger89/LeopardTrails/blob/master/README_ASSETS/how%20to%20identify.png" width="500">

Within the app, identification of the leopard is done using a ID image saved in the database and matching the ID image with the target image.

At the core we are relying on OpenCV+related algorithms for performing the match between the image of the leopard and the id card of the leopard.

The ID image and the information regarding the individual is stored witin the app so it can be used without a netowrk connection (which is mandatory if you are in the bush)

**To Do :** Implement a over the air update of the database to get the latest updates.


## Setting up the project

**Requirements :** 
1. Mac machine (my machine specs : Apple MacBook Pro 2018 16GB i7)
2. XCode and XCode commandline developer tools
3. Python
4. cmake
5. homebrew

#### Building the opencv framework

No need to follow this if you do not need to change the used opencv algorithms.

First major part of building the project (if you need to mess with the opencv) is building the opencv ios framework. This is one of the steps which I had to do most trial and error work.

Finally, got this working with following simple set of steps as most of the tutorials online adds unnecessary complexity to these steps.

- Download OpenCV source code
  - This can be cloned or downloaded from official github repo. https://github.com/opencv/opencv
- Download the OpenCV contrib source code
  - The patented algorithems are no longer a part of the opencv source code.
  - They have been moved to a new repo https://github.com/opencv/opencv_contrib
  - Make sure to download the correct version from the releases to match the opencv version
- Copy the required modules from contrib folder to the **Modules** of the opencv folder
  - In this scenario we would need **xfeature2d** folder only
- Open a terminal in the opencv root folder
- Run ```python platforms/ios/build_framework.py ios --enable_nonfree```
- The opencv.framework will be created in the build folder


#### Build and install LeopartTrails app

For instaiing the app in your iPhone, 

- Clone or download the source code
- install the pods
  - If you do not have cocoa pods install it using ```sudo gem install cocoapods```
  - Install pods for project
    - Navigate to the project root folder
    - ```pod install```
- Open ***LeopardTrails.xcworkspace*** with XCode
- Sign the application with your provision profile
  - For more information on the code sign and provision profile you can [read this nice article](https://medium.com/@abhimuralidharan/what-is-a-provisioning-profile-in-ios-77987a7c54c2)
  - You can install apps for in your personal devices withut any issue.
  - There is this nice article on [this link](https://ionicframework.com/blog/deploying-to-a-device-without-an-apple-developer-account/) which describes oh how to do that step-by-step
- Set your device as the target device in Xcode
- Build and Run the project 


  
 

  




