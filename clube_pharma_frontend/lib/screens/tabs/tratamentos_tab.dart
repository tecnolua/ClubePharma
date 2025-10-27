import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/collapsible_banner_wrapper.dart';
import '../../providers/treatment_provider.dart';

class TratamentosTab extends StatefulWidget {
  const TratamentosTab({super.key});

  @override
  State<TratamentosTab> createState() => _TratamentosTabState();
}

class _TratamentosTabState extends State<TratamentosTab> {
  @override
  void initState() {
    super.initState();
    // Carregar tratamentos ativos ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TreatmentProvider>().getActiveTreatments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final treatmentProvider = context.watch<TreatmentProvider>();

    return CollapsibleBannerWrapper(
      title: 'Meus Tratamentos',
      subtitle: 'Acompanhe seus medicamentos e receitas',
      gradientStart: Color(0xFFF59E0B),
      gradientEnd: Color(0xFFD97706),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card de Enviar Receita
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: AppColors.warning,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Envie sua Receita Médica',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tire uma foto e nós identificamos automaticamente',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.photo_camera),
                  label: Text('Tirar Foto da Receita'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warning,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Medicamentos Ativos
          Row(
            children: [
              Text(
                'Medicamentos Ativos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const Spacer(),
              if (treatmentProvider.isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Error handling
          if (treatmentProvider.error != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      treatmentProvider.error!,
                      style: TextStyle(color: Colors.red.shade900),
                    ),
                  ),
                  TextButton(
                    onPressed: () => treatmentProvider.getActiveTreatments(),
                    child: Text('Tentar novamente'),
                  ),
                ],
              ),
            )
          // Empty state
          else if (treatmentProvider.activeTreatments.isEmpty && !treatmentProvider.isLoading)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.medication_outlined, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum tratamento ativo',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Adicionar tratamento em desenvolvimento')),
                        );
                      },
                      icon: Icon(Icons.add),
                      label: Text('Adicionar Tratamento'),
                    ),
                  ],
                ),
              ),
            )
          // Lista de tratamentos
          else
            ...treatmentProvider.activeTreatments.map((treatment) {
              // Calcular dias restantes
              final now = DateTime.now();
              final endDate = treatment.endDate;
              int? diasRestantes;
              int? totalDias;

              if (endDate != null) {
                diasRestantes = endDate.difference(now).inDays;
                totalDias = endDate.difference(treatment.startDate).inDays;
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _MedicamentoCard(
                  nome: '${treatment.medicationName} ${treatment.dosage}',
                  horario: treatment.frequency,
                  dosagem: treatment.dosage,
                  diasRestantes: diasRestantes ?? 0,
                  totalDias: totalDias ?? 0,
                  isDark: isDark,
                ),
              );
            }),

          const SizedBox(height: 40),

          // Minhas Receitas
          Row(
            children: [
              Text(
                'Minhas Receitas',
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

          _ReceitaCard(
            titulo: 'Receita Cardiologia',
            medico: 'Dr. Carlos Silva',
            data: '15/03/2024',
            medicamentos: 2,
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _ReceitaCard(
            titulo: 'Receita Clínico Geral',
            medico: 'Dra. Ana Santos',
            data: '02/03/2024',
            medicamentos: 3,
            isDark: isDark,
          ),

          const SizedBox(height: 40),

          // Tratamentos Concluídos
          Text(
            'Tratamentos Concluídos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),

          const SizedBox(height: 20),

          _TratamentoConcluidoCard(
            nome: 'Amoxicilina 500mg',
            duracao: '7 dias',
            dataConclusao: '28/02/2024',
            isDark: isDark,
          ),

          const SizedBox(height: 16),

          _TratamentoConcluidoCard(
            nome: 'Azitromicina 500mg',
            duracao: '5 dias',
            dataConclusao: '15/02/2024',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _MedicamentoCard extends StatelessWidget {
  final String nome;
  final String horario;
  final String dosagem;
  final int diasRestantes;
  final int totalDias;
  final bool isDark;

  const _MedicamentoCard({
    required this.nome,
    required this.horario,
    required this.dosagem,
    required this.diasRestantes,
    required this.totalDias,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final progressoTratamento = diasRestantes / totalDias;

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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.medication,
                  color: AppColors.warning,
                  size: 24,
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
                          '$horario • $dosagem',
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

          const SizedBox(height: 16),

          // Progresso do Tratamento
          Row(
            children: [
              Text(
                'Tratamento',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
              ),
              const Spacer(),
              Text(
                '$diasRestantes de $totalDias dias',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressoTratamento,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check_circle, size: 18),
                  label: Text('Marcar como tomado'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: Text('Detalhes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceitaCard extends StatelessWidget {
  final String titulo;
  final String medico;
  final String data;
  final int medicamentos;
  final bool isDark;

  const _ReceitaCard({
    required this.titulo,
    required this.medico,
    required this.data,
    required this.medicamentos,
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
            child: Icon(Icons.description, color: AppColors.info, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  medico,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$data • $medicamentos medicamentos',
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

class _TratamentoConcluidoCard extends StatelessWidget {
  final String nome;
  final String duracao;
  final String dataConclusao;
  final bool isDark;

  const _TratamentoConcluidoCard({
    required this.nome,
    required this.duracao,
    required this.dataConclusao,
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
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check_circle, color: AppColors.accent, size: 22),
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
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Duração: $duracao',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Concluído em $dataConclusao',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
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
