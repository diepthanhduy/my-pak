const _withMarks =
    'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
const _base =
    'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

final _combiningMarks = RegExp('[̀-ͯ]');
final _whitespace = RegExp(r'\s+');

/// Lower-cases [text], strips Vietnamese diacritics and collapses whitespace,
/// so labels match whether the PDF uses precomposed or combining characters.
String foldVietnamese(String text) {
  final lower = text.toLowerCase().replaceAll(_combiningMarks, '');
  final buffer = StringBuffer();
  for (final char in lower.split('')) {
    final index = _withMarks.indexOf(char);
    buffer.write(index < 0 ? char : _base[index]);
  }
  return buffer.toString().replaceAll(_whitespace, ' ').trim();
}
