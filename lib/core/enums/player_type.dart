enum PlayerType { child, teen, adult }

extension PlayerTypeX on PlayerType {
  String get label {
    switch (this) {
      case PlayerType.child:
        return 'Criança';
      case PlayerType.teen:
        return 'Adolescente';
      case PlayerType.adult:
        return 'Adulto';
    }
  }

  String get initialTitle {
    switch (this) {
      case PlayerType.child:
        return 'Explorador(a) da Cidade';
      case PlayerType.teen:
        return 'Cidadão(ã) em Formação';
      case PlayerType.adult:
        return 'Condutor(a) Consciente';
    }
  }
}
