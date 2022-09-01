class DeleteLogEntriesDto {
  final List<String> ids;

  const DeleteLogEntriesDto(this.ids);

  Map<String, dynamic> toJson() => {'ids': ids};
}
