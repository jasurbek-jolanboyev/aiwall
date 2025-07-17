class SmartDevice {
  final String name;
  final String type;
  final String icon;
  final bool isOnline;

  SmartDevice({
    required this.name,
    required this.type,
    required this.icon,
    this.isOnline = true,
  });
}
