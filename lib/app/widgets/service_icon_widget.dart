import 'package:flutter/material.dart';
import '../data/models/service_model.dart';

/// Widget untuk menampilkan icon service
/// Support untuk Flutter Icon dan Image Asset
class ServiceIconWidget extends StatelessWidget {
  final ServiceModel service;
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final BoxFit? fit;

  const ServiceIconWidget({
    super.key,
    required this.service,
    this.size = 40,
    this.color,
    this.backgroundColor,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    if (service.hasImage && service.imageAsset != null) {
      // Render image from assets
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            service.imageAsset!,
            width: size,
            height: size,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to icon if image not found
              return Icon(
                service.flutterIcon,
                size: size * 0.6,
                color: color ?? Colors.blue[700],
              );
            },
          ),
        ),
      );
    }

    // Render Flutter Icon
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        service.flutterIcon,
        size: size * 0.6,
        color: color ?? Colors.blue[700],
      ),
    );
  }
}

/// Circular variant of service icon
class ServiceIconCircular extends StatelessWidget {
  final ServiceModel service;
  final double size;
  final Color? color;
  final Color? backgroundColor;

  const ServiceIconCircular({
    super.key,
    required this.service,
    this.size = 50,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (service.hasImage && service.imageAsset != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(size * 0.15),
        child: ClipOval(
          child: Image.asset(
            service.imageAsset!,
            width: size * 0.7,
            height: size * 0.7,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                service.flutterIcon,
                size: size * 0.5,
                color: color ?? Colors.blue[700],
              );
            },
          ),
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        service.flutterIcon,
        size: size * 0.5,
        color: color ?? Colors.blue[700],
      ),
    );
  }
}
