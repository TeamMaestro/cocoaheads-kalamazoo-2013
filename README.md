kzoo-cocoaheads-2013
====================

August 2013 — MapKit

* Location-based programming on iOS made up of two basic components location services & maps
* Location services provided by Core Location framework (user location & heading info)
* Maps provided by Map Kit framework (map views and annotations)

####Things & Stuff####
* Open address in Maps app with address string
* Geocoding (forward/reverse) to find locations on map
* Drop annotation on location
* Customize annotation view
* Region definition/zooming & panning map view
* Location search
	* Geocoding
	* Local search
	* 3rd party APIs (foursquare, yelp, Google Maps)
* Overlays, paths, routes
* Geofencing (used for background notifications hack — significant-change location service)
* Routing apps

*note to self — figure out where the magic happens and exploit it*

####APIs####
* MKMapView
* MKMapViewDelegate Protocol
* MKAnnotationView
* MKAnnotation Protocol
* MKPointAnnotation
* MKLocalSearch
* MKLocalSearchRequest
* MKLocalSearchResponse
* MKPlacemark
* MKUserLocation
* CLGeocoder
* CLLocationManager
* CLLocationManagerDelegate Protocol

---

###Sample Code###
User MKLocalSearch to find restaurants within 1.6 km radius. Show my current location and drop a custom pin/annotation for each restaurant in search results. Toggle map/list view and list restaurants by distance from current location, closest restaurants first.