class UpgradeDefinition {
  const UpgradeDefinition({
    required this.id,
    required this.zoneId,
    required this.title,
    required this.description,
    required this.cost,
  });

  final String id;
  final String zoneId;
  final String title;
  final String description;
  final int cost;
}
