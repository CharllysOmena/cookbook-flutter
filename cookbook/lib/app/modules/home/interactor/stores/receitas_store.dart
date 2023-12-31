import 'package:cookbook/app/modules/home/data/models/receita.dart';
import 'package:cookbook/app/modules/home/data/repositories/receitas_respository.dart';
import 'package:cookbook/app/modules/home/data/services/firebase_receita_favorita_service.dart';
import 'package:cookbook/app/modules/home/interactor/states/firebase_receita_favorita_state.dart';
import 'package:cookbook/app/modules/home/interactor/states/receita_state.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

part 'receitas_store.g.dart';

class ReceitasStore = _ReceitasStoreBase with _$ReceitasStore;

abstract class _ReceitasStoreBase with Store {
  final IReceitasRepository receitasRepository;

  final IFirebaseReceitaFavoritaService firebaseReceitaFavoritaService;

  _ReceitasStoreBase({
    required this.firebaseReceitaFavoritaService,
    required this.receitasRepository,
  });

  @observable
  ReceitaState state = const StartReceitaState();

  Receita? receita;

  @observable
  bool? isFavorite = false;

  @action
  Future getReceita(String id) async {
    state = const LoadingReceitaState();
    var response = await receitasRepository.get(id);
    (response is SuccessReceitaState) ? receita = response.receita : null;
    state = response;
  }

  @action
  Future favoritarReceita(Receita receita) async {
    var response = await firebaseReceitaFavoritaService.post(receita);
    if (response is SuccessFirebaseReceitaFavoritaState) {
      isFavorite = true;
      Fluttertoast.showToast(
        msg: "Receita Favoritada!",
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Erro ao favoritar receita!",
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }
  }

  @action
  Future verificaReceitaFavorita(String id) async {
    var response = await firebaseReceitaFavoritaService.findById(id);
    (response is SuccessFirebaseReceitaFavoritaState)
        ? isFavorite = true
        : isFavorite = false;
  }

  @action
  Future desfazerFavorito(String id) async {
    var response = await firebaseReceitaFavoritaService.delete(id);
    if (response is SuccessFirebaseReceitaFavoritaState) {
      isFavorite = false;
      Fluttertoast.showToast(
        msg: "Receita Retirada!",
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Erro ao retirar receita!",
        backgroundColor: Colors.amber,
        textColor: Colors.black,
      );
    }
  }
}
