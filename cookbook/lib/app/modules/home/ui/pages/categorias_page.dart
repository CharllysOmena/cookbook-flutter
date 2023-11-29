import 'package:cookbook/app/modules/home/interactor/states/categoria_state.dart';
import 'package:cookbook/app/modules/home/interactor/stores/categorias_store.dart';
import 'package:cookbook/app/modules/home/ui/widgets/loading.dart';
import 'package:cookbook/app/modules/home/ui/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CategoriasPage extends StatefulWidget {
  final String title;
  const CategoriasPage({Key? key, this.title = 'CategoriasPage'})
      : super(key: key);
  @override
  CategoriasPageState createState() => CategoriasPageState();
}

class CategoriasPageState extends State<CategoriasPage> {
  CategoriasStore store = Modular.get<CategoriasStore>();
  @override
  void initState() {
    store.getCategorias();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Observer(
          builder: (_) {
            if (store.state is LoadingCategoriaState) {
              return const Loading();
            } else if (store.state is SuccessCategoriaState) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: store.categorias!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (() {
                      Navigator.pushNamed(context, "/comidas",
                          arguments: store.categorias![index].nome);
                    }),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(store.categorias![index].url),
                          Text(
                            store.categorias![index].nome,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Error();
            }
          },
        ),
      ),
    );
  }
}
