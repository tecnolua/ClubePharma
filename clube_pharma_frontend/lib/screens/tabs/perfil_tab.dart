import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/collapsible_banner_wrapper.dart';
import '../../providers/auth_provider.dart';

class PerfilTab extends StatefulWidget {
  const PerfilTab({super.key});

  @override
  State<PerfilTab> createState() => _PerfilTabState();
}

class _PerfilTabState extends State<PerfilTab> {
  Future<void> _handleLogout() async {
    final authProvider = context.read<AuthProvider>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await authProvider.logout();
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return CollapsibleBannerWrapper(
      title: user?.name ?? 'Meu Perfil',
      subtitle: user?.email ?? 'Gerencie suas informações e preferências',
      gradientStart: Color(0xFF3B82F6),
      gradientEnd: Color(0xFF2563EB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card de Unificação de Exames - EXCLUSIVO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.purple.withValues(alpha: 0.15),
                  AppColors.info.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.purple.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.folder_special,
                      color: AppColors.purple,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Unificação de Exames Médicos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.purple,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'EXCLUSIVO CLUBEPHARMA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureItem(
                        icon: Icons.security,
                        text: '100% Seguro',
                        isDark: isDark,
                      ),
                    ),
                    Expanded(
                      child: _FeatureItem(
                        icon: Icons.share,
                        text: 'Compartilhamento Fácil',
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _FeatureItem(
                        icon: Icons.history,
                        text: 'Histórico Completo',
                        isDark: isDark,
                      ),
                    ),
                    Expanded(
                      child: _FeatureItem(
                        icon: Icons.stars,
                        text: 'Único no Mercado',
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Plano Atual
          Text(
            'Plano Atual',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.planType == 'FAMILY' ? 'Plano Família' : 'Plano Básico',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        Text(
                          user?.planType == 'FAMILY' ? 'R\$ 14,99/mês' : 'R\$ 7,99/mês',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('Gerenciar meu plano'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _BenefitItem(
                  icon: Icons.check_circle,
                  text: 'Consultas com desconto',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _BenefitItem(
                  icon: Icons.check_circle,
                  text: 'Farmácia com 15% OFF',
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _BenefitItem(
                  icon: Icons.check_circle,
                  text: 'Unificação de exames',
                  isDark: isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Meus Exames
          Row(
            children: [
              Text(
                'Meus Exames',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.add, size: 18),
                label: Text('Adicionar'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _ExameCard(
            tipo: 'Hemograma Completo',
            data: '15/03/2024',
            laboratorio: 'Lab. Saúde Total',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _ExameCard(
            tipo: 'Glicemia em Jejum',
            data: '10/03/2024',
            laboratorio: 'Lab. Vida',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _ExameCard(
            tipo: 'Colesterol Total',
            data: '05/03/2024',
            laboratorio: 'Lab. BioMed',
            isDark: isDark,
          ),

          const SizedBox(height: 40),

          // Conta
          Text(
            'Conta',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),

          const SizedBox(height: 20),

          _AccountItem(
            icon: Icons.person_outline,
            iconColor: AppColors.info,
            title: 'Informações Pessoais',
            subtitle: 'Nome, CPF, telefone',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _AccountItem(
            icon: Icons.receipt_long,
            iconColor: AppColors.primary,
            title: 'Histórico de Pedidos',
            subtitle: 'Ver pedidos anteriores',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _AccountItem(
            icon: Icons.location_on_outlined,
            iconColor: AppColors.purple,
            title: 'Endereços de Entrega',
            subtitle: 'Gerenciar endereços',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _AccountItem(
            icon: Icons.payment,
            iconColor: AppColors.warning,
            title: 'Métodos de Pagamento',
            subtitle: 'Cartões e formas de pagamento',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _AccountItem(
            icon: Icons.description,
            iconColor: AppColors.info,
            title: 'Receitas Médicas',
            subtitle: 'Gerenciar receitas médicas',
            isDark: isDark,
          ),

          const SizedBox(height: 40),

          // Botão Sair
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: authProvider.isLoading ? null : _handleLogout,
              icon: Icon(Icons.logout, color: AppColors.danger),
              label: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Sair da Conta',
                      style: TextStyle(
                        color: AppColors.danger,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: AppColors.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _FeatureItem({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.purple),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _BenefitItem({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.accent),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
      ],
    );
  }
}

class _ExameCard extends StatelessWidget {
  final String tipo;
  final String data;
  final String laboratorio;
  final bool isDark;

  const _ExameCard({
    required this.tipo,
    required this.data,
    required this.laboratorio,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.science, color: AppColors.info, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tipo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  laboratorio,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;

  const _AccountItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ],
      ),
    );
  }
}
