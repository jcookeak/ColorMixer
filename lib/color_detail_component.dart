import 'package:angular2/core.dart';
import 'color.dart';

@Component(
  selector: 'selected-color-detail',
  template: '''
<div *ngIf="color != null" [style.background-color]="color.hex" class="selected_color">
  <h2 [style.color]="color.textColor()">{{color.name}}</h2>
</div>
  ''',
  styles: const [ '''
  .selected_color {
    background-color: aquamarine;
    width: 600px;
    height: 600px;
    color: black;
    text-align: center;
}
  '''],
  styleUrls: const ['color_component.css'],
)

class ColorDetailComponent {
  @Input()
  Color color;

  void foo() {
    print(color.textColor());
  }
  //String background = color.hex;
}