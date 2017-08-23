import 'package:angular2/angular2.dart';

import 'color.dart';
import 'mom_colors.dart';

@Injectable() //emits metadata about service
class ColorService {
  List<Color> getColors() => momColors; //procionColors;
}