// Copyright (c) 2017, jonathoncooke-akaiwa. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'dart:async';

import 'color.dart';
import 'color_detail_component.dart';
import 'color_service.dart';
// AngularDart info: https://webdev.dartlang.org/angular
// Components info: https://webdev.dartlang.org/components

final List<Color> pink_elephant = [
  new Color("#FFC2CE", "Bluish Pink", 'Procion','111'),
  new Color("#80B3FF", "derie"),
  new Color("#FD6E8A", "Peony"),
  new Color("#A2122F", "Cherry"),
  new Color("#693726", "Iorna"),
  new Color("#FFFFFF", "Test White")
];

@Component(
  selector: 'my-colors',
  styleUrls: const ['color_component.css'],
  templateUrl: 'color_component.html',
  directives: const [materialDirectives, ColorDetailComponent],
  providers: const [materialProviders, ColorService],
)
class ColorComponent implements OnInit{
  List<Color> pallet;
//  final List<Color> pallet = procion;

  Color selectedColor;

  final ColorService _colorService;
  ColorComponent(this._colorService);

  Future<Null> getColors() async {
    pallet = await _colorService.getColors();
  }

  void ngOnInit() {
    getColors();
  }

  void onSelect(Color color) {
    selectedColor = color;
  }

}
