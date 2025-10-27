import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/clube_pharma_logo.dart';
import '../main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            top: false,
            child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                  // Linha separadora no topo
                  Container(
                    height: 1,
                    color: borderColor.withValues(alpha: 0.3),
                  ),

                  // Seção Hero Principal
                  Container(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge de Clube de Benefícios
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ClubePharmaLogo(size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'CLUBE DE BENEFÍCIOS',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Título Principal
                    RichText(
                      text: TextSpan(
                        style: Theme.of(
                          context,
                        ).textTheme.displayMedium?.copyWith(height: 1.2, fontSize: 32),
                        children: [
                          TextSpan(
                            text: 'Cuidado com a sua saúde, ',
                            style: TextStyle(color: textColor),
                          ),
                          const TextSpan(
                            text: 'simplificado',
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Descrição
                    Text(
                      'Economize até 40% em consultas médicas e 15% em medicamentos manipulados. Conecte-se com médicos especialistas e tenha entregas gratuitas.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textSecondary,
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botões de Ação
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Acessar Plataforma',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Navegar para tela de planos
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Conhecer Planos',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Estatísticas
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStat(context, '+10K', 'Clientes'),
                          _buildStat(context, '+500', 'Médicos'),
                          _buildStat(context, '4.9★', 'Avaliação'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Seção Por que escolher o ClubePharma
              Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: borderColor)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Por que escolher o ClubePharma?',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tudo que você precisa para cuidar da sua saúde',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Lista de Benefícios
                    ..._buildBenefits(context),

                    const SizedBox(height: 32),

                    // Seção FAQ
                    Text(
                      'Perguntas Frequentes',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Respostas para as perguntas mais comuns',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Lista de FAQ
                    ..._buildFAQs(context),

                    const SizedBox(height: 24),

                    // Card de Contato
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Ainda tem dúvidas?',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nossa equipe está pronta para ajudar você!',
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.phone, size: 18),
                                  label: const Text('0800 777 1234'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.help_outline,
                                    size: 18,
                                  ),
                                  label: const Text('Ajuda'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
      // Botão de tema flutuante
      Positioned(
        top: 8,
        right: 8,
        child: SafeArea(
          child: IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: AppColors.primary,
            ),
            onPressed: () {
              ThemeSwitcherProvider.of(context)?.toggleTheme();
            },
          ),
        ),
      ),
    ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: textSecondary)),
      ],
    );
  }

  List<Widget> _buildBenefits(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.trending_up,
        'color': AppColors.primary,
        'title': 'Economia Real',
        'desc':
            'Até 40% de desconto em consultas médicas e 15% em medicamentos manipulados. Quanto mais você usa, mais economiza.',
      },
      {
        'icon': Icons.medication,
        'color': AppColors.accent,
        'title': '15% OFF em medicamentos manipulados',
        'desc':
            'Desconto permanente em toda linha de medicamentos manipulados da nossa rede de farmácias parceiras.',
      },
      {
        'icon': Icons.local_shipping,
        'color': AppColors.info,
        'title': 'Entrega grátis ilimitada',
        'desc':
            'Receba seus medicamentos no conforto da sua casa sem pagar nada a mais. Válido para todos os pedidos dos planos Básico e Premium.',
      },
      {
        'icon': Icons.video_call,
        'color': AppColors.purple,
        'title': 'Telemedicina disponível',
        'desc':
            'Consulte médicos especialistas online de qualquer lugar. Presencial ou videochamada, você escolhe.',
      },
      {
        'icon': Icons.people,
        'color': AppColors.warning,
        'title': 'Plano Família Completo',
        'desc':
            'Cadastre até 4 membros da família. Gerencie medicamentos, consultas e exames de todos em um dashboard unificado.',
      },
      {
        'icon': Icons.calendar_today,
        'color': AppColors.info,
        'title': 'Agendamento facilitado',
        'desc':
            'Marque consultas em poucos cliques. Acesse centenas de especialistas das mais diversas áreas com desconto de até 40%.',
      },
    ];

    return benefits
        .map(
          (benefit) => _BenefitCard(
            icon: benefit['icon'] as IconData,
            color: benefit['color'] as Color,
            title: benefit['title'] as String,
            description: benefit['desc'] as String,
          ),
        )
        .toList();
  }

  List<Widget> _buildFAQs(BuildContext context) {
    final faqs = [
      {
        'q': 'Como funciona o ClubePharma?',
        'a':
            'O ClubePharma é um clube de benefícios que conecta você a médicos e farmácias parceiras com descontos exclusivos. Você tem acesso a consultas com desconto de até 40%, medicamentos manipulados com 15% OFF, entrega grátis e muito mais.',
      },
      {
        'q': 'Quais são os planos disponíveis?',
        'a':
            'Oferecemos 3 planos: Gratuito (funcionalidades básicas), Básico (R\$ 7,99/mês com descontos e entrega grátis) e Premium (R\$ 24,99/mês com todos os benefícios, incluindo plano família completo).',
      },
      {
        'q': 'Como agendar uma consulta médica?',
        'a':
            'É super simples! Acesse a aba "Consultas", escolha a especialidade que você precisa, veja os médicos disponíveis perto de você e clique em "Agendar". Você pode escolher entre consulta presencial ou telemedicina.',
      },
      {
        'q': 'A entrega é realmente grátis?',
        'a':
            'Sim! Assinantes dos planos Básico e Premium têm entrega totalmente gratuita e ilimitada em todos os pedidos de medicamentos. Sem valor mínimo de compra e sem limite de pedidos por mês.',
      },
    ];

    return faqs
        .map(
          (faq) => _FAQItem(
            question: faq['q'] as String,
            answer: faq['a'] as String,
          ),
        )
        .toList();
  }
}

class _BenefitCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _BenefitCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.chevron_right, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 4),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
