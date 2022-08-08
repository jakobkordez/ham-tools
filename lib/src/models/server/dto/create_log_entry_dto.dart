class CreateLogEntryDto {
  final String? owner;
  final DateTime? createdAt;
  final Map<String, String> data;

  const CreateLogEntryDto({
    this.owner,
    this.createdAt,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        if (owner != null) 'owner': owner,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        'data': data,
      };
}
