import 'package:flutter/material.dart';
import 'neighborhood_scene_geometry.dart';
import 'neighborhood_upgrade_layer.dart';

/// Shows a contextual crop without changing the coordinates of the intervention.
/// Both the illustration and every purchased layer share the same transform.
class NeighborhoodSceneFocus extends StatelessWidget {
  const NeighborhoodSceneFocus({
    super.key,
    required this.asset,
    required this.zoneId,
    required this.focusId,
    required this.purchased,
    this.previewId,
    this.night = false,
  });

  final String asset;
  final String zoneId;
  final String focusId;
  final Set<String> purchased;
  final String? previewId;
  final bool night;

  static Rect cropFor(String zoneId, String upgradeId) {
    final surface = neighborhoodSurfaces[zoneId]?[upgradeId];
    if (surface == null) {
      return Offset.zero & neighborhoodArtworkSize;
    }
    final ground = surface.path.getBounds();
    final bounds = ground.expandToInclude(
      ground.translate(0,
          surface.kind == NeighborhoodSurfaceKind.lighting ? -110 : -35),
    );
    // Minimum context includes the adjoining sidewalk and road. Crops never
    // pan outside the image, even for the school's foreground crossing.
    final width = (bounds.width + 180).clamp(420.0, 1672.0).toDouble();
    final height = (bounds.height + 180).clamp(330.0, 941.0).toDouble();
    final left = (bounds.center.dx - width / 2)
        .clamp(0.0, neighborhoodArtworkSize.width - width).toDouble();
    final top = (bounds.center.dy - height / 2)
        .clamp(0.0, neighborhoodArtworkSize.height - height).toDouble();
    return Rect.fromLTWH(left, top, width, height);
  }

  @override
  Widget build(BuildContext context) {
    final crop = cropFor(zoneId, focusId);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF062565),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF27DBFF), width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: RepaintBoundary(
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: crop.width,
                  height: crop.height,
                  child: ClipRect(
                    child: Stack(
                      children: [
                        Positioned(
                          left: -crop.left,
                          top: -crop.top,
                          width: neighborhoodArtworkSize.width,
                          height: neighborhoodArtworkSize.height,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(asset, fit: BoxFit.fill,
                                  excludeFromSemantics: true),
                              if (night)
                                const ColoredBox(color: Color(0x88051C44)),
                              NeighborhoodUpgradeLayer(
                                zoneId: zoneId,
                                purchased: purchased,
                                previewId: previewId,
                                night: night,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
