import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/collapsible_banner_wrapper.dart';

class FarmaciaTab extends StatefulWidget {
  const FarmaciaTab({super.key});

  @override
  State<FarmaciaTab> createState() => _FarmaciaTabState();
}

class _FarmaciaTabState extends State<FarmaciaTab> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CollapsibleBannerWrapper(
      title: 'Farmácia',
      subtitle: 'Compre seus medicamentos com desconto',
      gradientStart: Color(0xFF10B981),
      gradientEnd: Color(0xFF059669),
      trailing: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.shopping_cart,
            color: Colors.white,
            size: 24,
          ),
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Text(
                '3',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                // 1. PESQUISAR MEDICAMENTOS
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar Produtos',
                          prefixIcon: Icon(Icons.search, color: AppColors.primary),
                          filled: true,
                          fillColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.sync, color: AppColors.primary, size: 16),
                            const SizedBox(width: 8),
                            Text(
                              'Integrado com Bling ERP',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. BANNER - Card de Receita Médica
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: AppColors.primary,
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Peça rápido com prescrição médica',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tire uma foto da sua receita',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.upload_file, size: 18),
                              label: Text('Enviar receita'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. HISTÓRICO DO CLIENTE
                Text(
                  'Histórico de Pedidos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),

                const SizedBox(height: 20),

                _PedidoCard(
                  numeroPedido: '#12345',
                  data: '15/03/2024',
                  itens: 3,
                  status: 'Entregue',
                  statusColor: AppColors.accent,
                  produtos: [
                    {'nome': 'Dipirona 500mg', 'qtd': 2, 'preco': 'R\$ 15,90'},
                    {'nome': 'Paracetamol 750mg', 'qtd': 1, 'preco': 'R\$ 12,50'},
                    {'nome': 'Ibuprofeno 600mg', 'qtd': 1, 'preco': 'R\$ 18,90'},
                  ],
                  total: 'R\$ 47,30',
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _PedidoCard(
                  numeroPedido: '#12344',
                  data: '10/03/2024',
                  itens: 2,
                  status: 'Em trânsito',
                  statusColor: AppColors.info,
                  produtos: [
                    {'nome': 'Omeprazol 20mg', 'qtd': 1, 'preco': 'R\$ 22,00'},
                    {'nome': 'Vitamina D 2000UI', 'qtd': 1, 'preco': 'R\$ 35,90'},
                  ],
                  total: 'R\$ 57,90',
                  isDark: isDark,
                ),

                const SizedBox(height: 40),

                // 4. PROMOÇÕES PARA VOCÊ
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.local_offer, color: AppColors.accent, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Promoções Para Você',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Produtos recomendados com desconto especial',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ProdutoCard(
                        nome: 'Dipirona 500mg',
                        descricao: 'Caixa com 20 comprimidos',
                        precoOriginal: 'R\$ 19,90',
                        precoDesconto: 'R\$ 15,90',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                      _ProdutoCard(
                        nome: 'Vitamina C 1000mg',
                        descricao: 'Frasco com 60 cápsulas',
                        precoOriginal: 'R\$ 45,00',
                        precoDesconto: 'R\$ 35,90',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                      _ProdutoCard(
                        nome: 'Protetor Solar FPS 50',
                        descricao: 'Frasco de 200ml',
                        precoOriginal: 'R\$ 65,00',
                        precoDesconto: 'R\$ 52,00',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                      _ProdutoCard(
                        nome: 'Paracetamol 750mg',
                        descricao: 'Caixa com 10 comprimidos',
                        precoOriginal: 'R\$ 15,00',
                        precoDesconto: 'R\$ 12,00',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 5. PROMOÇÕES RELÂMPAGO 24H
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.danger.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.flash_on, color: AppColors.danger, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Promoções Relâmpago 24h',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.timer, color: AppColors.danger, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '02:45:32',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.danger,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ofertas válidas por tempo limitado!',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _ProdutoCard(
                        nome: 'Whey Protein 900g',
                        descricao: 'Sabor chocolate',
                        precoOriginal: 'R\$ 120,00',
                        precoDesconto: 'R\$ 89,90',
                        desconto: '25%',
                        isDark: isDark,
                        isPromocao: true,
                      ),
                      _ProdutoCard(
                        nome: 'Colágeno Hidrolisado',
                        descricao: 'Pote com 250g',
                        precoOriginal: 'R\$ 80,00',
                        precoDesconto: 'R\$ 59,90',
                        desconto: '25%',
                        isDark: isDark,
                        isPromocao: true,
                      ),
                      _ProdutoCard(
                        nome: 'Ômega 3 1000mg',
                        descricao: 'Frasco com 120 cápsulas',
                        precoOriginal: 'R\$ 60,00',
                        precoDesconto: 'R\$ 44,90',
                        desconto: '25%',
                        isDark: isDark,
                        isPromocao: true,
                      ),
                      _ProdutoCard(
                        nome: 'Multivitamínico',
                        descricao: 'Caixa com 60 comprimidos',
                        precoOriginal: 'R\$ 50,00',
                        precoDesconto: 'R\$ 37,50',
                        desconto: '25%',
                        isDark: isDark,
                        isPromocao: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 6. CATEGORIAS
                Text(
                  'Categorias',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Navegue por categorias de produtos',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 4.5,
                  children: [
                    _CategoriaCard(
                      icon: Icons.medical_services,
                      titulo: 'Medicamentos',
                      descricao: '15% OFF',
                      cor: AppColors.primary,
                      isDark: isDark,
                    ),
                    _CategoriaCard(
                      icon: Icons.favorite,
                      titulo: 'Dermocosméticos',
                      descricao: '20% OFF',
                      cor: AppColors.purple,
                      isDark: isDark,
                    ),
                    _CategoriaCard(
                      icon: Icons.fitness_center,
                      titulo: 'Suplementos',
                      descricao: 'Novidades',
                      cor: AppColors.warning,
                      isDark: isDark,
                    ),
                    _CategoriaCard(
                      icon: Icons.child_care,
                      titulo: 'Infantil',
                      descricao: 'Ver todos',
                      cor: AppColors.info,
                      isDark: isDark,
                    ),
                  ],
                ),
              ],
      ),
    );
  }
}

// Card de Pedido Expansível
class _PedidoCard extends StatefulWidget {
  final String numeroPedido;
  final String data;
  final int itens;
  final String status;
  final Color statusColor;
  final List<Map<String, dynamic>> produtos;
  final String total;
  final bool isDark;

  const _PedidoCard({
    required this.numeroPedido,
    required this.data,
    required this.itens,
    required this.status,
    required this.statusColor,
    required this.produtos,
    required this.total,
    required this.isDark,
  });

  @override
  State<_PedidoCard> createState() => _PedidoCardState();
}

class _PedidoCardState extends State<_PedidoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.numeroPedido,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.statusColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.status,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: widget.statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.data} • ${widget.itens} itens',
                          style: TextStyle(
                            fontSize: 14,
                            color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: widget.isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(height: 1, color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ...widget.produtos.map((produto) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '${produto['qtd']}x',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                produto['nome'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                                ),
                              ),
                            ),
                            Text(
                              produto['preco'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 8),
                  Divider(height: 1, color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.total,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('Pedir Novamente'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Ver Detalhes'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Card de Produto
class _ProdutoCard extends StatelessWidget {
  final String nome;
  final String descricao;
  final String precoOriginal;
  final String precoDesconto;
  final String desconto;
  final bool isDark;
  final bool isPromocao;

  const _ProdutoCard({
    required this.nome,
    required this.descricao,
    required this.precoOriginal,
    required this.precoDesconto,
    required this.desconto,
    required this.isDark,
    this.isPromocao = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Center(
                  child: Icon(
                    Icons.medical_services,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPromocao ? AppColors.danger : AppColors.accent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    desconto,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  precoOriginal,
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      precoDesconto,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card de Categoria
class _CategoriaCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;
  final Color cor;
  final bool isDark;

  const _CategoriaCard({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.cor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: cor, size: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Text(
                    descricao,
                    style: TextStyle(
                      fontSize: 10,
                      color: cor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
