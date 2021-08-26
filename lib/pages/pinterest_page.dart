import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/widgets/pinterest_menu.dart';
import 'package:provider/provider.dart';

class PinterestPage extends StatelessWidget {
  const PinterestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new _MenuModel(),
      child: Scaffold(
        // body: PinterestMenu(),
        // body: PinterestGrid(),
        body: Stack(
          children: [
            PinterestGrid(),
            _PinterestMenuLocation(),
          ],
        ),
      ),
    );
  }
}

class _PinterestMenuLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mostrar = Provider.of<_MenuModel>(context).mostrar;

    // el widget positioned sirve para posicionar un widget dentro de un stack
    return Positioned(
      bottom: 30,
      child: Container(
        width: width,
        child: Align(
          child: PinterestMenu(
            mostrar: mostrar,
            // backgroundColor: Colors.red,
            // activeColor: Colors.red,
            // inactiveColor: Colors.blue,
            items: [
              PinterestButton(
                icon: Icons.pie_chart,
                onPressed: () {
                  print('icon pie_chart');
                },
              ),
              PinterestButton(
                icon: Icons.search,
                onPressed: () {
                  print('icon search');
                },
              ),
              PinterestButton(
                icon: Icons.notifications,
                onPressed: () {
                  print('icon notifications');
                },
              ),
              PinterestButton(
                icon: Icons.supervised_user_circle,
                onPressed: () {
                  print('icon supervised_user_circle');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PinterestGrid extends StatefulWidget {
  @override
  _PinterestGridState createState() => _PinterestGridState();
}

class _PinterestGridState extends State<PinterestGrid> {
  final List<int> items = List.generate(200, (index) => index);

  ScrollController controller = new ScrollController();
  double scrollAnterior = 0;

  @override
  void initState() {
    controller.addListener(() {
      // print('listener ${controller.offset}');
      // print(controller.position.userScrollDirection);
      // if (controller.offset > scrollAnterior && controller.offset > 150) {
      //   print('ocultar menu');
      //   Provider.of<_MenuModel>(context, listen: false).mostrar = false;
      // } else {
      //   print('Mostrar menu');
      //   Provider.of<_MenuModel>(context, listen: false).mostrar = true;
      // }

      // scrollAnterior = controller.offset;

      // segunda manera de detectar el scroll
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        // ocultar menu
        print('ocultar menu');
        Provider.of<_MenuModel>(context, listen: false).mostrar = false;
      } else {
        // mostrar menu
        print('mostrar menu');
        Provider.of<_MenuModel>(context, listen: false).mostrar = true;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    this.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      controller: controller,
      crossAxisCount: 4,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) => _PinterestItem(index),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}

class _PinterestItem extends StatelessWidget {
  final int index;

  _PinterestItem(this.index);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      child: new Center(
        child: new CircleAvatar(
          backgroundColor: Colors.white,
          child: new Text('$index'),
        ),
      ),
    );
  }
}

class _MenuModel with ChangeNotifier {
  bool _mostrar = true;
  bool get mostrar => this._mostrar;
  set mostrar(bool valor) {
    this._mostrar = valor;
    notifyListeners();
  }
}
