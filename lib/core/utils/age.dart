/// Age split into whole years and the remaining whole months.
typedef Age = ({int years, int months});

/// Computes the age at [reference] of someone born on [dob].
///
/// A [dob] after [reference] yields zero.
Age ageOf(DateTime dob, DateTime reference) {
  var totalMonths =
      (reference.year - dob.year) * 12 + reference.month - dob.month;
  if (reference.day < dob.day) totalMonths--;
  if (totalMonths < 0) totalMonths = 0;
  return (years: totalMonths ~/ 12, months: totalMonths % 12);
}
