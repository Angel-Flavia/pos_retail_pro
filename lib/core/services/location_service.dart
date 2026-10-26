import 'package:geolocator/geolocator.dart'; 
 
class LocationService { 
  static Future<Position?> getCurrentLocation() async { 
    try { 
      final enabled = await Geolocator.isLocationServiceEnabled(); 
      if (!enabled) return null; 
      var perm = await Geolocator.checkPermission(); 
      if (perm == LocationPermission.denied) { 
        perm = await Geolocator.requestPermission(); 
      } 
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) { 
        return null; 
      } 
      return await Geolocator.getCurrentPosition(desiredAccuracy: 
LocationAccuracy.medium).timeout(const Duration(seconds: 5)); 
    } catch (_) { 
      return null; 
    } 
  } 
}