import 'package:angular/angular.dart';
import 'package:webui/src/generated/epantry.pbgrpc.dart';
import 'package:webui/src/generated/google/protobuf/empty.pb.dart';

import 'src/todo_list/todo_list_component.dart';

// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: [TodoListComponent],
)
class AppComponent implements OnInit{
  ePantryClient service;
  String version;
  AppComponent(this.service);


  @override
  void ngOnInit() async {
    version = (await service.version(Empty())).version;
  }
}
