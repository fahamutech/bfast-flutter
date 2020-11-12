class UpdateModel {
  Map<dynamic, dynamic> $set;
  Map<dynamic, dynamic> $inc;
  Map<dynamic, dynamic> $currentDate;
  Map<dynamic, dynamic> $min;
  Map<dynamic, dynamic> $max;
  Map<dynamic, dynamic> $mul;
  Map<dynamic, dynamic> $rename;
  Map<dynamic, dynamic> $unset;

  UpdateModel(
      {this.$set,
      this.$currentDate,
      this.$inc,
      this.$max,
      this.$min,
      this.$mul,
      this.$rename,
      this.$unset});
}
