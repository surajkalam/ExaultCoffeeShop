// // location_screen.dart
// import 'package:coffee_shop/Features/Map/provider/locationprovider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationScreen extends ConsumerStatefulWidget {
//   const LocationScreen({super.key});

//   @override
//   ConsumerState<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends ConsumerState<LocationScreen> {
//   @override
//   void initState() {
//     super.initState();

//     // Fetch location when screen initializes
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(locationProvider.notifier).fetchLocation();
//     });
//   }

//   Widget _buildLoadingState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Imagesmapsplashscreen.png",
//           height: 100,
//           width: 150,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 30),
//         const CircularProgressIndicator(),
//         const SizedBox(height: 20),
//         const Text(
//           'Finding your location...',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState(String errorMessage) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Images/mapsplashscreen12.png",
//           height: 100,
//           width: 150,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 30),
//         const Icon(Icons.error_outline, color: Colors.red, size: 50),
//         const SizedBox(height: 20),
//         Text(
//           errorMessage,
//           style: const TextStyle(color: Colors.red, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: () => ref.read(locationProvider.notifier).fetchLocation(),
//           child: const Text('Try Again'),
//         ),
//       ],
//     );
//   }

//   Widget _buildSuccessState(Position position, String address,double height,double width) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Images/mapsplashscreen12.png",
//           height: height*0.22,
//           width: width*0.34,
//           fit: BoxFit.contain,
//         ),
//          SizedBox(height:height*0.01),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Text(
//             address,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.blue,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 10),
//         // Text(
//         //   'Lat: ${position.latitude.toStringAsFixed(6)}, '
//         //   'Lng: ${position.longitude.toStringAsFixed(6)}',
//         //   style: const TextStyle(fontSize: 12, color: Colors.grey),
//         // ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locationState = ref.watch(locationProvider);
//     var width=MediaQuery.of(context).size.width;
//     var height=MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: locationState.isLoading
//               ? _buildLoadingState()
//               : locationState.errorMessage.isNotEmpty
//                   ? _buildErrorState(locationState.errorMessage)
//                   : _buildSuccessState(locationState.position!, locationState.address,height,width),
//         ),
//       ),
//     );
//   }
// }

 //above code 1st preference 
// correct code without riverpod


// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key});

//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }

// class _LocationScreenState extends State<LocationScreen> {
//   Position? _currentPosition;
//   String _errorMessage = '';
//   bool _isLoading = true;
//   String _address = 'Fetching your location...';

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocation();
//   }

//   Future<void> _fetchLocation() async {
//     try {
//       final position = await _determinePosition();
//       setState(() {
//         _currentPosition = position;
//       });

//       final address = await _convertCoordinatesToAddress(
//         position.latitude,
//         position.longitude,
//       );

//       setState(() {
//         _address = address;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//         _address = 'Failed to get location';
//       });
//     }
//   }

//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied');
//     }

//     return await Geolocator.getCurrentPosition(
//       locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
//     );
//   }

//   Future<String> _convertCoordinatesToAddress(
//     double latitude,
//     double longitude,
//   ) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(latitude, longitude);

//       if (placemarks.isEmpty) {
//         return 'Address not found';
//       }

//       final Placemark place = placemarks[0];
//       final List<String> addressParts = [];

//       if (place.street != null && place.street!.isNotEmpty) {
//         addressParts.add(place.street!);
//       }

//       if (place.subLocality != null && place.subLocality!.isNotEmpty) {
//         addressParts.add(place.subLocality!);
//       } else if (place.locality != null && place.locality!.isNotEmpty) {
//         addressParts.add(place.locality!);
//       }

//       if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
//         addressParts.add(place.administrativeArea!);
//       }

//       if (place.postalCode != null && place.postalCode!.isNotEmpty) {
//         addressParts.add(place.postalCode!);
//       }

//       if (place.country != null && place.country!.isNotEmpty) {
//         addressParts.add(place.country!);
//       }

//       return addressParts.isEmpty ? 'Address information not available' : addressParts.join(', ');
//     } catch (e) {
//       return 'Could not get address';
//     }
//   }

//   Widget _buildLoadingState(double height,double width) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Imagesmapsplashscreen.png",
//           height: height*0.2,
//           width:width*0.1,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 30),
//         const CircularProgressIndicator(),
//         const SizedBox(height: 20),
//         const Text(
//           'Finding your location...',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//       ],
//     );
//   }

//   Widget _buildErrorState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Imagesmapsplashscreen.png",
//           height: 100,
//           width: 150,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 30),
//         const Icon(Icons.error_outline, color: Colors.red, size: 50),
//         const SizedBox(height: 20),
//         Text(
//           _errorMessage,
//           style: const TextStyle(color: Colors.red, fontSize: 16),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: _fetchLocation,
//           child: const Text('Try Again'),
//         ),
//       ],
//     );
//   }

//   Widget _buildSuccessState() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(
//           "Assets/Images/mapsplashscreen.png",
//           height: 100,
//           width: 150,
//           fit: BoxFit.contain,
//         ),
//         const SizedBox(height: 30),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Text(
//             _address,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.blue,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         const SizedBox(height: 10),
//         // Text(
//         //   'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, '
//         //   'Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
//         //   style: const TextStyle(fontSize: 12, color: Colors.grey),
//         // ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     var width=MediaQuery.of(context).size.width;
//     var height=MediaQuery.of(context).size.width;
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: _isLoading
//               ? _buildLoadingState(height,width)
//               : _errorMessage.isNotEmpty
//                   ? _buildErrorState()
//                   : _buildSuccessState(),
//         ),
//       ),
//     );
//   }
// }

//check animation
//
// location_screen.dart
import 'package:coffee_shop/Features/Map/mapscreen.dart';
import 'package:coffee_shop/Features/Map/provider/locationprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart'; // Make sure you have go_router package

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _imageAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start animations
    _controller.forward();

    // Fetch location and setup navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).fetchLocation().then((_) {
        // Navigate to home after 3 seconds of showing location
        Future.delayed(const Duration(seconds: 7), () {
          if (mounted) {
            context.go('/navbar');
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _imageAnimation,
          child: Image.asset(
            "Assets/Images/mapsplashscreen12.png",
            height: 100,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 30),
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _textAnimation,
          child: const Text(
            'Finding your location...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _imageAnimation,
          child: Image.asset(
            "Assets/Images/mapsplashscreen12.png",
            height: 100,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 30),
        FadeTransition(
          opacity: _textAnimation,
          child: const Icon(Icons.error_outline, color: Colors.red, size: 50),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _textAnimation,
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _textAnimation,
          child: ElevatedButton(
            onPressed: () => ref.read(locationProvider.notifier).fetchLocation(),
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }
//   void navigateToMapScreen(BuildContext context, dynamic state) {
//   if (state.position != null) {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => const MapScreen()),
//     );
//   }
// }

  Widget _buildSuccessState(Position position, String address,) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FadeTransition(
          opacity: _imageAnimation,
          child: ScaleTransition(
            scale: _imageAnimation,
            child: Image.asset(
              "Assets/Images/mapsplashscreen12.png",
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 30),
        FadeTransition(
          opacity: _textAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(_textAnimation),
             child: ElevatedButton(
            onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    latitude: position.latitude,
                    longitude: position.longitude,
                    address: address,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text('View on Map'),
          ),
          ),
        ),
        const SizedBox(height: 20),
        FadeTransition(
          opacity: _textAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(_textAnimation),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                address,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        FadeTransition(
          opacity: _textAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(_textAnimation),
          ),
        ),
      ],
    );
    
  }
  // Add this to your LocationProvider notifier


  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: locationState.isLoading
                ? _buildLoadingState()
                : locationState.errorMessage.isNotEmpty
                    ? _buildErrorState(locationState.errorMessage)
                    : _buildSuccessState(locationState.position!, locationState.address),
          ),
        ),
      ),
    );
  }
}
