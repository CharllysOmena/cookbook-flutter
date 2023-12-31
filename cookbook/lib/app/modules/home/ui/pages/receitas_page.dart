import 'package:cookbook/app/modules/home/interactor/stores/receitas_store.dart';
import 'package:cookbook/app/modules/home/ui/widgets/detalhes_receita.dart';
import 'package:cookbook/app/modules/home/ui/widgets/loading.dart';
import 'package:cookbook/app/modules/home/ui/widgets/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../interactor/states/receita_state.dart';

class ReceitasPage extends StatefulWidget {
  final String title;
  const ReceitasPage({Key? key, this.title = 'Receita'}) : super(key: key);
  @override
  ReceitasPageState createState() => ReceitasPageState();
}

class ReceitasPageState extends State<ReceitasPage> {
  ReceitasStore store = Modular.get<ReceitasStore>();
  String id = Modular.args!.data.toString();

  @override
  void initState() {
    store.verificaReceitaFavorita(id);
    store.getReceita(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
        actions: [
          Observer(builder: (context) {
            if (store.state is SuccessReceitaState) {
              return Observer(builder: (context) {
                return (store.isFavorite!)
                    ? IconButton(
                        onPressed: () => store..desfazerFavorito(id),
                        icon: const Icon(Icons.favorite))
                    : IconButton(
                        onPressed: () => store.favoritarReceita(store.receita!),
                        icon: const Icon(Icons.favorite_border_outlined));
              });
            } else {
              return Container();
            }
          })
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.state is LoadingReceitaState) {
            return const Loading();
          } else if (store.state is SuccessReceitaState) {
            return SingleChildScrollView(
                padding: const EdgeInsets.all(4),
                child: DetalhesReceita(store: store));
          } else if (store.state is ErrorExceptionReceitaState) {
            return const Error();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
