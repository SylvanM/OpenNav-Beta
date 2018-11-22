# OpenNav

OpenNav is an open-source iOS application made to download and navigate layouts of buildings, campuses, cities, and more.

## Basic operation
Every registered layout has an access code. To retrieve the layout, enter the respective access code into the settings of the app. The layouts will be downloaded onto the app and stored, so that internet connection is not required to view or navigate the layouts, only to download them.

The layouts are stored on the web service navdataservice.000webhostapp.com and are encrypted using AES-CBC (we are working to change that to AES-GCM) to protect potentially private information from being too publically available.

To ensure that the layouts are securely transfered to your device, on first launch of the app, a pair of RSA keys are generated, as well as a hex string unique to your device. The public key and hex id are uploaded a database of users so the server can encrypt information to your device.

**NOTE:** This app is a work in progress. Until the app is published, assume the information on the web service **will not be secure**.

## Tutorial
