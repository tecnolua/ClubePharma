import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../widgets/collapsible_banner_wrapper.dart';

class FamiliaTab extends StatelessWidget {
  const FamiliaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return CollapsibleBannerWrapper(
      title: 'Minha Família',
      subtitle: 'Gerencie os perfis da sua família',
      gradientStart: Color(0xFF8B5CF6),
      gradientEnd: Color(0xFF7C3AED),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Botão adicionar membro
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
              label: const Text('Adicionar Membro da Família'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Membros da família
          Text(
            'Membros (3/4)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),

          _MembroCard(
            nome: 'Você',
            relacao: 'Titular',
            idade: '35 anos',
            proximaConsulta: 'Cardiologia - 25 Out',
            borderColor: borderColor,
            textColor: textColor,
            textSecondary: textSecondary,
            isPrincipal: true,
          ),

          const SizedBox(height: 16),

          _MembroCard(
            nome: 'Maria Silva',
            relacao: 'Cônjuge',
            idade: '33 anos',
            proximaConsulta: 'Dermatologia - 28 Out',
            borderColor: borderColor,
            textColor: textColor,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 16),

          _MembroCard(
            nome: 'João Silva',
            relacao: 'Filho',
            idade: '8 anos',
            proximaConsulta: 'Pediatria - 30 Out',
            borderColor: borderColor,
            textColor: textColor,
            textSecondary: textSecondary,
          ),

          const SizedBox(height: 40),

          // Benefícios do plano família
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.workspace_premium, color: AppColors.warning, size: 28),
                    const SizedBox(width: 12),
                    Text(
                      'Benefícios do Plano Família',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _BeneficioItem(
                  icon: Icons.check_circle,
                  text: 'Até 4 membros da família',
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 6),
                _BeneficioItem(
                  icon: Icons.check_circle,
                  text: 'Dashboard unificado para todos',
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 6),
                _BeneficioItem(
                  icon: Icons.check_circle,
                  text: 'Descontos em todas as consultas',
                  textSecondary: textSecondary,
                ),
                const SizedBox(height: 6),
                _BeneficioItem(
                  icon: Icons.check_circle,
                  text: 'Entrega grátis de medicamentos',
                  textSecondary: textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MembroCard extends StatelessWidget {
  final String nome;
  final String relacao;
  final String idade;
  final String proximaConsulta;
  final Color borderColor;
  final Color textColor;
  final Color textSecondary;
  final bool isPrincipal;

  const _MembroCard({
    required this.nome,
    required this.relacao,
    required this.idade,
    required this.proximaConsulta,
    required this.borderColor,
    required this.textColor,
    required this.textSecondary,
    this.isPrincipal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isPrincipal ? AppColors.primary : borderColor,
          width: isPrincipal ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPrincipal ? Icons.person : Icons.person_outline,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (isPrincipal) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Principal',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$relacao • $idade',
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 13, color: AppColors.accent),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        proximaConsulta,
                        style: TextStyle(fontSize: 12, color: AppColors.accent),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _BeneficioItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color textSecondary;

  const _BeneficioItem({
    required this.icon,
    required this.text,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: textSecondary),
          ),
        ),
      ],
    );
  }
}
