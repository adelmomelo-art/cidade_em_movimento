class FaixitaResponse {
  const FaixitaResponse({required this.text, required this.source});

  final String text;
  final FaixitaResponseSource source;
}

enum FaixitaResponseSource { local, remote }
