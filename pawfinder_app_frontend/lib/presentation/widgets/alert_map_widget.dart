import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/entities/alert.dart';

/// Interactive OpenStreetMap showing nearby lost-pet alerts.
/// Uses flutter_map (no API key required — powered by OpenStreetMap tiles).
class AlertMapWidget extends StatelessWidget {
  final List<Alert> alerts;
  final LatLng center;
  final double defaultZoom;
  final void Function(Alert alert)? onAlertTap;

  const AlertMapWidget({
    super.key,
    this.alerts = const [],
    this.center = const LatLng(-26.2041, 28.0473), // Johannesburg
    this.defaultZoom = 13.0,
    this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      child: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: defaultZoom,
          minZoom: 3,
          maxZoom: 18,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          // OpenStreetMap tile layer (free, no API key)
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.pawfinder.app',
            maxZoom: 19,
            // Fallback to offline-friendly styling
            tileBuilder: (context, tileWidget, tile) {
              return ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.9, 0.0, 0.0, 0.0, 0.0,
                  0.0, 0.9, 0.0, 0.0, 0.0,
                  0.0, 0.0, 0.9, 0.0, 0.0,
                  0.0, 0.0, 0.0, 1.0, 0.0,
                ]),
                child: tileWidget,
              );
            },
          ),
          // Rich attribution with link
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => {},
              ),
            ],
          ),
          // Alert markers
          MarkerLayer(
            markers: alerts
                .where((a) => a.fuzzedLat != 0.0 || a.fuzzedLng != 0.0)
                .map((alert) => _buildAlertMarker(context, alert))
                .toList(),
          ),
          // GPS/my-location button
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: _MyLocationButton(),
            ),
          ),
        ],
      ),
    );
  }

  Marker _buildAlertMarker(BuildContext context, Alert alert) {
    final position = LatLng(alert.fuzzedLat, alert.fuzzedLng);

    final emoji = _speciesEmoji(alert);
    final isActive = alert.status == AlertStatus.active;

    return Marker(
      point: position,
      width: 48,
      height: 56,
      child: GestureDetector(
        onTap: () => onAlertTap?.call(alert),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Marker pin
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppColors.primary : AppColors.ink500,
                border: Border.all(
                  color: Colors.white,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isActive ? AppColors.primary : AppColors.ink500)
                        .withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Pointer
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.ink500,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _speciesEmoji(Alert alert) {
    final species = alert.species.toLowerCase();
    if (species.contains('dog') || species.contains('canine')) return '🐕';
    if (species.contains('cat') || species.contains('feline')) return '🐈';
    if (species.contains('bird')) return '🐦';
    if (species.contains('rabbit') || species.contains('bunny')) return '🐰';
    return '🐾';
  }
}

/// Semi-transparent "locate me" button overlay.
class _MyLocationButton extends StatelessWidget {
  const _MyLocationButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // The map controller would be used here via a callback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📍 Locating...'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink900.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.my_location,
          color: AppColors.primary,
          size: 22,
        ),
      ),
    );
  }
}
