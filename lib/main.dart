import 'package:flutter/material.dart';

void main() {
  runApp(const TeaFalaApp());
}

class TeaFalaApp extends StatefulWidget {
  const TeaFalaApp({super.key});

  @override
  State<TeaFalaApp> createState() => _TeaFalaAppState();
}

class _TeaFalaAppState extends State<TeaFalaApp> {
  bool _isDark = false;

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEA Fala',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TEA Fala'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final cat = _categorias[index];
          return _CategoriaCard(
            emoji: cat.emoji,
            nome: cat.nome,
            total: cat.total,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CategoriaScreen(
                    categoria: cat.nome,
                    itens: _itensDaCategoria(cat.id),
                    isDark: isDark,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<ItemComunicacao> _itensDaCategoria(String id) {
    return _todosItens.where((i) => i.categoriaId == id).toList();
  }

  List<CategoriaItem> get _categorias => [
    CategoriaItem(id: 'necessidades', nome: 'Necessidades', emoji: '🍽️', total: '7 ícones'),
    CategoriaItem(id: 'pessoas', nome: 'Pessoas', emoji: '👥', total: '5 ícones'),
    CategoriaItem(id: 'emocoes', nome: 'Emoções', emoji: '❤️', total: '6 ícones'),
    CategoriaItem(id: 'lugares', nome: 'Lugares', emoji: '📍', total: '5 ícones'),
    CategoriaItem(id: 'acoes', nome: 'Ações', emoji: '🏃‍♂️', total: '6 ícones'),
  ];

  List<ItemComunicacao> get _todosItens => [
    // Necessidades
    ItemComunicacao(id: 'fome', rotulo: 'Tenho fome', emoji: '🍎', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'sede', rotulo: 'Tenho sede', emoji: '💧', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'banheiro', rotulo: 'Vou ao banheiro', emoji: '🚽', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'sono', rotulo: 'Estou com sono', emoji: '😴', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'dor', rotulo: 'Sinto dor', emoji: '🤕', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'frio', rotulo: 'Estou com frio', emoji: '🧣', categoriaId: 'necessidades'),
    ItemComunicacao(id: 'calor', rotulo: 'Estou com calor', emoji: '☀️', categoriaId: 'necessidades'),

    // Pessoas
    ItemComunicacao(id: 'mae', rotulo: 'Mãe', emoji: '👩', categoriaId: 'pessoas'),
    ItemComunicacao(id: 'pai', rotulo: 'Pai', emoji: '👨', categoriaId: 'pessoas'),
    ItemComunicacao(id: 'avo', rotulo: 'Vovó', emoji: '👵', categoriaId: 'pessoas'),
    ItemComunicacao(id: 'professor', rotulo: 'Professor', emoji: '👩‍🏫', categoriaId: 'pessoas'),
    ItemComunicacao(id: 'amigo', rotulo: 'Amigo', emoji: '👦', categoriaId: 'pessoas'),

    // Emoções
    ItemComunicacao(id: 'feliz', rotulo: 'Estou feliz', emoji: '😊', categoriaId: 'emocoes'),
    ItemComunicacao(id: 'triste', rotulo: 'Estou triste', emoji: '😢', categoriaId: 'emocoes'),
    ItemComunicacao(id: 'bravo', rotulo: 'Estou bravo', emoji: '😠', categoriaId: 'emocoes'),
    ItemComunicacao(id: 'assustado', rotulo: 'Estou assustado', emoji: '😨', categoriaId: 'emocoes'),
    ItemComunicacao(id: 'calmo', rotulo: 'Estou calmo', emoji: '😌', categoriaId: 'emocoes'),
    ItemComunicacao(id: 'confuso', rotulo: 'Estou confuso', emoji: '😕', categoriaId: 'emocoes'),

    // Lugares
    ItemComunicacao(id: 'casa', rotulo: 'Casa', emoji: '🏠', categoriaId: 'lugares'),
    ItemComunicacao(id: 'escola', rotulo: 'Escola', emoji: '🏫', categoriaId: 'lugares'),
    ItemComunicacao(id: 'medico', rotulo: 'Médico', emoji: '🏥', categoriaId: 'lugares'),
    ItemComunicacao(id: 'parque', rotulo: 'Parque', emoji: '🌳', categoriaId: 'lugares'),
    ItemComunicacao(id: 'loja', rotulo: 'Loja', emoji: '🛒', categoriaId: 'lugares'),

    // Ações
    ItemComunicacao(id: 'parar', rotulo: 'Pare', emoji: '🛑', categoriaId: 'acoes'),
    ItemComunicacao(id: 'ajuda', rotulo: 'Quero ajuda', emoji: '🆘', categoriaId: 'acoes'),
    ItemComunicacao(id: 'brincar', rotulo: 'Quero brincar', emoji: '🧸', categoriaId: 'acoes'),
    ItemComunicacao(id: 'sentar', rotulo: 'Quero sentar', emoji: '🪑', categoriaId: 'acoes'),
    ItemComunicacao(id: 'andar', rotulo: 'Quero andar', emoji: '🚶', categoriaId: 'acoes'),
    ItemComunicacao(id: 'terminou', rotulo: 'Terminei', emoji: '✅', categoriaId: 'acoes'),
  ];
}

class CategoriaItem {
  final String id;
  final String nome;
  final String emoji;
  final String total;
  CategoriaItem({required this.id, required this.nome, required this.emoji, required this.total});
}

class ItemComunicacao {
  final String id;
  final String rotulo;
  final String emoji;
  final String categoriaId;
  ItemComunicacao({required this.id, required this.rotulo, required this.emoji, required this.categoriaId});
}

class _CategoriaCard extends StatelessWidget {
  final String emoji;
  final String nome;
  final String total;
  final VoidCallback onTap;

  const _CategoriaCard({
    required this.emoji,
    required this.nome,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              nome,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              total,
              style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriaScreen extends StatelessWidget {
  final String categoria;
  final List<ItemComunicacao> itens;
  final bool isDark;

  const CategoriaScreen({
    super.key,
    required this.categoria,
    required this.itens,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoria),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: itens.length,
        itemBuilder: (context, index) {
          final item = itens[index];
          return ItemBotao(item: item);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FraseScreen(itensDisponiveis: itens),
            ),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Frase'),
      ),
    );
  }
}

class ItemBotao extends StatelessWidget {
  final ItemComunicacao item;

  const ItemBotao({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              item.rotulo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class FraseScreen extends StatefulWidget {
  final List<ItemComunicacao> itensDisponiveis;

  const FraseScreen({super.key, required this.itensDisponiveis});

  @override
  State<FraseScreen> createState() => _FraseScreenState();
}

class _FraseScreenState extends State<FraseScreen> {
  final List<ItemComunicacao> _frase = [];

  void _adicionar(ItemComunicacao item) {
    setState(() {
      _frase.add(item);
    });
  }

  void _remover(int index) {
    setState(() {
      _frase.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Montar Frase'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_frase.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Frase:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _frase.asMap().entries.map((entry) {
                      final i = entry.key;
                      final item = entry.value;
                      return Chip(
                        label: Text('${item.emoji} ${item.rotulo}'),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _remover(i),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpar'),
                    onPressed: () => setState(() => _frase.clear()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: widget.itensDisponiveis.length,
              itemBuilder: (context, index) {
                final item = widget.itensDisponiveis[index];
                return ItemBotao(
                  item: item,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
