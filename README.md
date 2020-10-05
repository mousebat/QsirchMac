# QsirchMac

A MacOS app for searching QNAP Devices **for MacOS Catalina Only**

***

QsirchMac leverages the QSirch API on supported QNAP devices.  It allows you to search for files, preview them in a sidebar and then reveal them in Finder by clicking the preview. It requires your QNAP product to have a valid SSL certificate and domain name.

QSirch Mac is a work in progress, there will be bugs and I encourage people to post any issues you come across either here on GitHub or on the QNAP forum: https://forum.qnap.com/viewtopic.php?f=361&t=153194

I'm not a developer by trade and this app was created for use in my own business but I will do my best to squash bugs and add features if it's inside my capability.  QSirchMac is initially limited to MacOS Catalina but I may open it up to older versions of MacOS. When BigSur is released I will hopefully, depending on how busy I am and the demand, rework it for release on the AppStore.

## USAGE
On first open the app will take you to the server details dialog box. Enter your hostname, username and password for your QNAP user's account, then click **Test** to check your details.  Clicking **Save** will store your details for further future access.

The search dialog box will then appear and list the available share points for the user on the left under the search bar.  You can filter the results using the drop down pickers on the right of the share points. 

You don't have to be connected to any share points in Finder to display results but you will not receive any nice Quicklook generated thumbnails (they will show as no entry symbols) and you obviously won't be able to reveal the items in Finder.

## HISTORY
I bought my QNAP NAS to replace an ageing MacPro, stuffed to the brim with SATA drives running OS X Server.  We were fast running out of storage and rather than just buy new larger drives I decided to go with a NAS that was neat enough to put in a shelf in our network cabinet.  The Spotlight compatibility was the main selling point, as my staff use Spotlight on a daily basis to cut through the millions of files we store, so you can imagine my disappointment when it did not work as advertised.  I waited about 3 months with an open support ticket and after no solution appeared I created QsirchMac to bridge the gap.

I hope you enjoy using it, if you want to buy me a pint feel free here:
paypal.me/qsirchmac
