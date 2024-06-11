enum PermissionGroup {
  camera, // Android: Camera; iOS: Photos (Camera Roll & Camera)
  location, // Android: Fine & Coarse Location; iOS: CoreLocation (Always & WhenInUse)
  locationAlways, // Android: < Q: Fine & Coarse Location, >= Q: Background Location; iOS: CoreLocation - Always
  locationWhenInUse, // Android: Fine & Coarse Location; iOS: CoreLocation - WhenInUse
  microphone, // Android: Microphone; iOS: Microphone
  notification, // Android: Notification; iOS: Notification
  phone, // Android: Phone iOS: Nothing
  photos, // Android: Nothing; iOS: Photos iOS 14+ read & write access level
  photosAddOnly, // Android: Nothing; iOS: Photos iOS 14+ read & write access level
  storage, // Android: External Storage; iOS: Access to folders like Documents or Downloads. Implicitly granted.
}
