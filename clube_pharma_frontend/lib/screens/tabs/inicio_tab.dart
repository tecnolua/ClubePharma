import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class InicioTab extends StatelessWidget {
  const InicioTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Padding responsivo: mobile (32px) vs web/desktop (maior padding baseado na largura)
    final double horizontalPadding = screenWidth > 600
        ? (screenWidth * 0.15).clamp(80.0, 300.0) // Web: 15% da largura, mín 80px, máx 300px
        : 32.0; // Mobile: 32px

    return SingleChildScrollView(
      child: Column(
        children: [
          // Banner Azul com Saudação
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6),
                  Color(0xFF2563EB),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Olá, João! ',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '👋',
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Seu cuidado começa aqui',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo principal
          Padding(
            padding: EdgeInsets.only(left: horizontalPadding, right: horizontalPadding, top: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TRATAMENTOS ATIVOS
                Text(
                  'Tratamentos Ativos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Seus tratamentos em andamento',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                _TratamentoAtivoCard(
                  nome: 'Losartana 50mg',
                  horario: '08:00',
                  progresso: 0.70,
                  diasRestantes: 21,
                  totalDias: 30,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _TratamentoAtivoCard(
                  nome: 'Atorvastatina 20mg',
                  horario: '20:00',
                  progresso: 0.40,
                  diasRestantes: 12,
                  totalDias: 30,
                  isDark: isDark,
                ),

                const SizedBox(height: 40),

                // TRATAMENTOS TERMINANDO
                Text(
                  'Terminando',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tratamentos próximos do fim',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                _TratamentoTerminandoItem(
                  usuario: 'João (Você)',
                  medicamento: 'Omeprazol 20mg',
                  diasRestantes: 3,
                  progresso: 0.90,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _TratamentoTerminandoItem(
                  usuario: 'Maria (Filha)',
                  medicamento: 'Amoxicilina 500mg',
                  diasRestantes: 2,
                  progresso: 0.93,
                  isDark: isDark,
                  isFamilia: true,
                ),

                const SizedBox(height: 40),

                // PRÓXIMOS VENCIMENTOS
                Text(
                  'Próximos Vencimentos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Medicamentos que estão vencendo',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                _VencimentoItem(
                  usuario: 'João (Você)',
                  medicamento: 'Vitamina D 2000UI',
                  dataVencimento: '05/11/2025',
                  diasParaVencer: 13,
                  progresso: 0.65,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _VencimentoItem(
                  usuario: 'Pedro (Filho)',
                  medicamento: 'Complexo B',
                  dataVencimento: '10/11/2025',
                  diasParaVencer: 18,
                  progresso: 0.70,
                  isDark: isDark,
                  isFamilia: true,
                ),

                const SizedBox(height: 16),

                _VencimentoItem(
                  usuario: 'Maria (Filha)',
                  medicamento: 'Xarope Pediátrico',
                  dataVencimento: '01/11/2025',
                  diasParaVencer: 9,
                  progresso: 0.45,
                  isDark: isDark,
                  isFamilia: true,
                ),

                const SizedBox(height: 40),

                // ESPECIALISTAS MAIS PRÓXIMOS
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Especialistas mais próximos de você',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('Ver todos'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _MedicoCard(
                        avatar: 'JP',
                        nome: 'Dr. João Pediatra',
                        especialidade: 'Pediatria',
                        rating: 4.8,
                        distancia: '1,2 km',
                        precoOriginal: 'R\$ 200',
                        precoDesconto: 'R\$ 160',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                      _MedicoCard(
                        avatar: 'MC',
                        nome: 'Dra. Maria Cardiologista',
                        especialidade: 'Cardiologia',
                        rating: 4.9,
                        distancia: '800 m',
                        precoOriginal: 'R\$ 250',
                        precoDesconto: 'R\$ 200',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                      _MedicoCard(
                        avatar: 'CS',
                        nome: 'Dr. Carlos Silva',
                        especialidade: 'Clínico Geral',
                        rating: 4.7,
                        distancia: '1,5 km',
                        precoOriginal: 'R\$ 150',
                        precoDesconto: 'R\$ 120',
                        desconto: '20%',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // BLOG CLUBEPHARMA
                Row(
                  children: [
                    Icon(Icons.article, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Blog ClubePharma',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('Ver mais'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Artigos de saúde para você',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),

                const SizedBox(height: 20),

                _ArtigoCard(
                  imagem: Icons.favorite,
                  categoria: 'Saúde do Coração',
                  titulo: 'Como prevenir doenças cardiovasculares',
                  tempoLeitura: '5 min',
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _ArtigoCard(
                  imagem: Icons.psychology,
                  categoria: 'Saúde Mental',
                  titulo: 'A importância da saúde mental no dia a dia',
                  tempoLeitura: '7 min',
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _ArtigoCard(
                  imagem: Icons.restaurant,
                  categoria: 'Nutrição',
                  titulo: 'Alimentação saudável: por onde começar?',
                  tempoLeitura: '6 min',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Card de Tratamento Ativo
class _TratamentoAtivoCard extends StatelessWidget {
  final String nome;
  final String horario;
  final double progresso;
  final int diasRestantes;
  final int totalDias;
  final bool isDark;

  const _TratamentoAtivoCard({
    required this.nome,
    required this.horario,
    required this.progresso,
    required this.diasRestantes,
    required this.totalDias,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                child: Icon(Icons.medication, color: AppColors.accent, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Tomar às $horario',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                '$diasRestantes de $totalDias dias',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const Spacer(),
              Text(
                '${(progresso * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// Item de Tratamento Terminando
class _TratamentoTerminandoItem extends StatelessWidget {
  final String usuario;
  final String medicamento;
  final int diasRestantes;
  final double progresso;
  final bool isDark;
  final bool isFamilia;

  const _TratamentoTerminandoItem({
    required this.usuario,
    required this.medicamento,
    required this.diasRestantes,
    required this.progresso,
    required this.isDark,
    this.isFamilia = false,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFamilia ? Icons.family_restroom : Icons.person,
                color: isFamilia ? AppColors.purple : AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  usuario,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$diasRestantes dias',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            medicamento,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
          ),
        ],
      ),
    );
  }
}

// Item de Vencimento
class _VencimentoItem extends StatelessWidget {
  final String usuario;
  final String medicamento;
  final String dataVencimento;
  final int diasParaVencer;
  final double progresso;
  final bool isDark;
  final bool isFamilia;

  const _VencimentoItem({
    required this.usuario,
    required this.medicamento,
    required this.dataVencimento,
    required this.diasParaVencer,
    required this.progresso,
    required this.isDark,
    this.isFamilia = false,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFamilia ? Icons.family_restroom : Icons.person,
                color: isFamilia ? AppColors.purple : AppColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  usuario,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              Icon(Icons.calendar_today, size: 14, color: AppColors.danger),
              const SizedBox(width: 4),
              Text(
                dataVencimento,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            medicamento,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vence em $diasParaVencer dias',
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progresso,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

// Card de Médico (horizontal scroll)
class _MedicoCard extends StatelessWidget {
  final String avatar;
  final String nome;
  final String especialidade;
  final double rating;
  final String distancia;
  final String precoOriginal;
  final String precoDesconto;
  final String desconto;
  final bool isDark;

  const _MedicoCard({
    required this.avatar,
    required this.nome,
    required this.especialidade,
    required this.rating,
    required this.distancia,
    required this.precoOriginal,
    required this.precoDesconto,
    required this.desconto,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
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
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  avatar,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      especialidade,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.location_on, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text(
                distancia,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                precoOriginal,
                style: TextStyle(
                  fontSize: 13,
                  decoration: TextDecoration.lineThrough,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                precoDesconto,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  desconto,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Agendar'),
            ),
          ),
        ],
      ),
    );
  }
}

// Card de Artigo do Blog
class _ArtigoCard extends StatelessWidget {
  final IconData imagem;
  final String categoria;
  final String titulo;
  final String tempoLeitura;
  final bool isDark;

  const _ArtigoCard({
    required this.imagem,
    required this.categoria,
    required this.titulo,
    required this.tempoLeitura,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(imagem, color: AppColors.primary, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      categoria,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.info,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      const SizedBox(width: 4),
                      Text(
                        tempoLeitura,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
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
      ),
    );
  }
}
