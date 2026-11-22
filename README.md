# Achados & Perdidos App — XII SEMAC (UFS)
Projeto prático desenvolvido para o minicurso **Desenvolvimento de Aplicativos Móveis com Flutter** na **XII SEMAC**.

---

## Objetivo
Um aplicativo para controle e devolução de itens perdidos no campus universitário, construído de forma **simples, didática e direta**, sem bibliotecas complexas ou autenticação.

---

## Estrutura do Projeto (`lib/`)

```text
lib/
├── models/
│   └── item_model.dart             # Modelo de dados simples (atributos e método devolver)
├── services/
│   └── item_service.dart           # Lista em memória e métodos para listar, cadastrar e devolver
├── views/
│   ├── splash_screen.dart          # Tela de abertura com logo da UFS
│   ├── home_screen.dart            # Tela principal com abas [Perdidos | Devolvidos]
│   └── components/                 # Componentes reutilizáveis
│       ├── item_card.dart         
│       ├── novo_item_sheet.dart  
│       ├── detalhe_item_sheet.dart
│       └── devolver_sheet.dart    
└── main.dart                      
```

---

## Como Executar

### No FlutLab.io (Navegador):
1. Importe o projeto zipado;
2. Clique no botão de **Build** para visualizar no simulador web.

### No Computador (VS Code):
1. Abra a pasta `Achados&PerdidosApp` no VS Code (`File > Open Folder...`);
2. Abra o terminal integrado e execute:
   ```bash
   flutter pub get
   ```
3. Pressione `F5` para rodar no seu celular via USB ou no Google Chrome
