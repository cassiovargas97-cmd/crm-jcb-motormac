# CRM JCB MOTORMAC

Sistema de CRM móvel completo para vendedores de campo de máquinas linha amarela (JCB e MOTORMAC).

## Características

- ✅ Interface amigável com cores da marca JCB
- ✅ Modo offline com sincronização
- ✅ Segmentação de clientes (Construção e Agro)
- ✅ Gestão de leads e visitas
- ✅ Geolocalização de visitas
- ✅ Propostas comerciais
- ✅ Dashboard e relatórios

## Tecnologias

- Flutter 3.0+
- SQLite (banco local)
- Provider (state management)
- Google Maps
- Geolocator

## Como Compilar

### Pré-requisitos
- Flutter SDK 3.0 ou superior
- Android Studio / Xcode (para iOS)

### Passos

1. Instalar dependências:
```bash
flutter pub get
```

2. Gerar APK Android:
```bash
flutter build apk --release
```

3. Gerar AAB (para Google Play):
```bash
flutter build appbundle --release
```

## Estrutura do Projeto

```
lib/
├── models/          # Modelos de dados
├── services/        # Serviços (auth, database, sync)
├── screens/         # Telas do aplicativo
├── utils/           # Utilitários e temas
└── main.dart        # Ponto de entrada
```

## Credenciais de Teste

Para testar o app, use qualquer email e senha não vazios.

## Suporte

Para dúvidas ou problemas, entre em contato.
