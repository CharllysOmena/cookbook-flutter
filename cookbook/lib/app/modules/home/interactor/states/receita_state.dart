import '../../data/models/receita.dart';

abstract interface class ReceitaState {}

class StartReceitaState implements ReceitaState {
  const StartReceitaState();
}

class SuccessReceitaState implements ReceitaState {
  final List<Receita> receitas;
  const SuccessReceitaState({required this.receitas});
}

class ErrorExceptionReceitaState implements ReceitaState {
  const ErrorExceptionReceitaState();
}

class LoadingReceitaState implements ReceitaState {
  const LoadingReceitaState();
}

class EmptyReceitaState implements ReceitaState {
  const EmptyReceitaState();
}
