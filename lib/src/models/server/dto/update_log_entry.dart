class UpdateLogEntryDto {
  final String? owner;
  final DateTime? createdAt;
  final Map<String, String>? data;

  const UpdateLogEntryDto({
    this.owner,
    this.createdAt,
    this.data,
  });

  Map<String, dynamic> toJson() => {
        if (owner != null) 'owner': owner,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (data != null) 'data': data,
      };
}
