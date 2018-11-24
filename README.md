# OpenNav

OpenNav is an open-source iOS application made to download and navigate layouts of buildings, campuses, cities, and more.

## Basic operation
Every registered layout has an access code. To retrieve the layout, enter the respective access code into the settings of the app. The layouts will be downloaded onto the app and stored, so that internet connection is not required to view or navigate the layouts, only to download them.

The layouts are stored on the web service navdataservice.000webhostapp.com and are encrypted using AES-CBC (we are working to change that to AES-GCM) to protect potentially private information from being too publically available.

To ensure that the layouts are securely transfered to your device, on first launch of the app, a pair of RSA keys are generated, as well as a hex string unique to your device. The public key and hex id are uploaded a database of users so the server can encrypt information to your device.

**NOTE:** This app is a work in progress. Until the app is published, assume the information on the web service **will not be secure**.

## Tutorial

The following tutorial will guide you through first launch, and downloading a test layout.

1. Launch OpenNav. Upon first launch, the app will have generated an app ID, public and private key, and will have uploaded them to the database assuming you have an internet connection. The app should open into the **Map View**, the default view. There should be an alert telling you that you must download some layouts.
![OpenNav on first launch](https://github.com/OpenNavDeveloper/OpenNav/blob/master/Tutorial%20Images/fresh_launch.png)

2. Select the **settings** icon in the top right corner. In the `Enter facility code` text field, enter `test`. Press "done" on the onscreen keybord. If you are running OpenNav in a simulator, press enter on your keyboard.
![OpenNav on first launch](https://github.com/OpenNavDeveloper/OpenNav/blob/master/Tutorial%20Images/entering_test.png)
![OpenNav on first launch](https://github.com/OpenNavDeveloper/OpenNav/blob/master/Tutorial%20Images/downloading.png)
