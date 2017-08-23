import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';

import 'color_service.dart';
import 'color_component.dart';
import 'mixer_component.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <nav>
      <a [routerLink] = "['Colors']">Colors</a>
      <a [routerLink] = "['Mixer']">Mixer</a>
    </nav>
    <router-outlet></router-outlet>
  ''',
  directives: const [ROUTER_DIRECTIVES],
  providers: const [ColorService, ROUTER_PROVIDERS],
)

@RouteConfig(const [
  const Route(path: 'colors', name: 'Colors', component: ColorComponent, useAsDefault: true),
  const Route(path: 'mixer', name:'Mixer', component: MixerComponent),
])

class AppComponent {
  final title = "Color Mixer";
}