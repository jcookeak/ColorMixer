import 'package:angular2/angular2.dart';
import 'dart:async';

import 'color.dart';
import 'mixer.dart';
import 'color_service.dart';
import 'color_operations.dart';
import 'color_service.dart';

@Component(
  selector: 'mixer',
template: '''
  <h3>Color Mixer</h3>
  <div>
    <label>color: </label>
    <input [(ngModel)]="target.hex" placeholder="{{target.hex}}">
    <div [style.background-color]= "target.hex" class="input_color"></div>
    <button (click)="findColor()">find closest color</button>
    <div *ngFor="let r of results">
      <div *ngIf="r != null" [style.background-color]= "r.hex" class="result">
        <h3 [style.color]="r.textColor()">{{r.hex}}</h3>
      </div>
    </div>
    <!--<h4 *ngIf="result != null">difference is: {{diff.hex}}</h4> !-->
  </div>
  <h3>Color Diff</h3>
  <div>
  <label>color 1: </label>
  <input [(ngModel)]="diff_1.hex" placeholder="{{diff_1.hex}}">
  <div [style.background-color]= "diff_1.hex" class="input_color"></div>
  <label>color 2: </label>
  <input [(ngModel)]="diff_2.hex" placeholder="{{diff_2.hex}}">
  <div [style.background-color]= "diff_2.hex" class="input_color"></div>
  <button (click)="colorDiff(diff_1, diff_2)">Mix</button>
  <div *ngIf="diff_out != null" [style.background-color]="diff_out.hex" class="result"></div>
  <div *ngIf="diff_out != null">{{diff_out.hex}}</div>
  </div>
  <h3>Mix Two Colors</h3>
  <div>
  <label>color 1: </label>
  <input [(ngModel)]="mix_1.hex" placeholder="{{mix_1.hex}}">
  <div [style.background-color]= "mix_1.hex" class="input_color"></div>
  <input [(ngModel)]="mix_ratio" type="range" value="{{mix_ratio}}" min="0" max="1.0" step="0.05">
  <div>ratio is {{mix_ratio}}</div>
  <label>color 2: </label>
  <input [(ngModel)]="mix_2.hex" placeholder="{{mix_2.hex}}">
  <div [style.background-color]= "mix_2.hex" class="input_color"></div>
  <button (click)="mixColor(mix_1, mix_2, mix_ratio)">Mix</button>
  <div *ngIf="mix_r != null" [style.background-color]="mix_r.hex" class="result"></div>
  <div *ngIf="mix_r != null">{{mix_r.hex}}</div>
  </div>
  <h3>In Margin of Error</h3>
  <div>
  <label>color 1: </label>
  <input [(ngModel)]="mar_1.hex" placeholder="{{mar_1.hex}}">
  <div [style.background-color]= "mar_1.hex" class="input_color"></div>
  <label>color 2: </label>
  <input [(ngModel)]="mar_2.hex" placeholder="{{mar_2.hex}}">
  <div [style.background-color]= "mar_2.hex" class="input_color"></div>
  <button (click)="isEqual(mar_1, mar_2)">Check</button>
  <div *ngIf="mar_out != null">{{mar_out}}</div>
  </div>
  
''',
  styles: const[
    '''
    .input_color {
      display: inline-block;
      height: 20px;
      width: 20px;
    } 
    
    .result {
      height: 100px;
      width: 100px;
    }
    '''],
)

class MixerComponent implements OnInit {
  Color target = new Color("#000000");
  String color = '#000000';

  Color diff_1 = new Color("#000000");
  Color diff_2 = new Color("#000000");
  Color diff_out = null;

  Color mix_1 = new Color("#000000");
  Color mix_2 = new Color("#000000");
  var mix_ratio = 0.5;
  Color mix_r = null;

  Color mar_1 = new Color("#000000");
  Color mar_2 = new Color("#000000");
  String mar_out = "";

  Color result;
  Color diff;

  List<Color> pallet;

  List<Color> results = new List<Color>();

  final ColorService _colorService;
  MixerComponent(this._colorService);

  Future<Null> getColors() async {
    pallet = await _colorService.getColors();
  }

  void ngOnInit() {
    getColors();

  }

  void findColor([num COUNT = 8]) {

    results = new List<Color>();
    Mixer mixer = new Mixer(pallet, target);

    while (COUNT > 0) {
      result = mixer.closestColor(target);
      print("result is: " + result.hex);
      if (mixer.isEqual(target.hexToInt(), result.hexToInt())) {
        print("found correct color");
        COUNT = 0;
      }
      print("finding new target with old t and r: " + target.hex + ", " + result.hex);
      target = mixer.colorDiff(target, result);
      print("target is now: " + target.hex);
      if (result != null) {
        results.add(result);
        print("added: " + result.hex);
      }
      else {
        print("result is null");
      }
      COUNT -= 1;
    }
  }

//  void mixColor(Color c1, Color c2, ratio) {
//    Mixer mixer = new Mixer();
//    print("ratio: " + ratio.toString());
//    mix_r = mixer.mixColors(c1, c2, num.parse(ratio.toString())); //handle whitespace
//  }

  void mixColor(Color c1, Color c2, ratio) {
    Mixer mixer = new Mixer();

    if (ratio == null) {
      ratio = '0.5';
    } else {
      ratio = ratio.toString();
    }
    print("ratio: " + ratio.toString());
    mix_r = mixColors([c1, c2], [2 * num.parse(ratio),2 * (1-num.parse(ratio))]); //handle whitespace
  }

  void colorDiff(Color c1, Color c2) {
    Mixer mixer = new Mixer();
    diff_out = mixer.colorDiff(c1, c2);
  }

  void isEqual(Color c1, Color c2){
    Mixer mixer = new Mixer();
    mar_out = mixer.isEqual(c1.hexToInt(), c2.hexToInt()).toString();
  }
}