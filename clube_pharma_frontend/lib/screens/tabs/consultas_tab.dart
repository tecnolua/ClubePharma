import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/collapsible_banner_wrapper.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/appointment_provider.dart';

class ConsultasTab extends StatefulWidget {
  const ConsultasTab({super.key});

  @override
  State<ConsultasTab> createState() => _ConsultasTabState();
}

class _ConsultasTabState extends State<ConsultasTab> {
  String _selectedEspecialidade = 'Todas';
  bool _consultasExpanded = true;

  @override
  void initState() {
    super.initState();
    // Carregar médicos e consultas ao iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorProvider>().getDoctors();
      context.read<AppointmentProvider>().getAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doctorProvider = context.watch<DoctorProvider>();
    final appointmentProvider = context.watch<AppointmentProvider>();

    return CollapsibleBannerWrapper(
      title: 'Consultas',
      subtitle: 'Busque especialistas e agende consultas',
      gradientStart: Color(0xFF10B981),
      gradientEnd: Color(0xFF059669),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                // 1. CONSULTAS AGENDADAS (COLAPSÁVEL)
                InkWell(
                  onTap: () => setState(() => _consultasExpanded = !_consultasExpanded),
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
                        Icon(Icons.event, color: AppColors.accent, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          'Consultas Agendadas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '2',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _consultasExpanded ? Icons.expand_less : Icons.expand_more,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_consultasExpanded) ...[
                  const SizedBox(height: 20),
                  _ConsultaAgendadaCard(
                    medico: 'Dr. Carlos Silva',
                    especialidade: 'Cardiologia',
                    data: '25 Out 2025',
                    horario: '14:30',
                    local: 'Centro Cardíaco - Sala 203',
                    avatar: 'CS',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  _ConsultaAgendadaCard(
                    medico: 'Dra. Ana Santos',
                    especialidade: 'Clínico Geral',
                    data: '28 Out 2025',
                    horario: '09:00',
                    local: 'Telemedicina',
                    avatar: 'AS',
                    isTelemedicina: true,
                    isDark: isDark,
                  ),
                ],

                const SizedBox(height: 40),

                // 2. PUBLICIDADE MÉDICA
                Text(
                  'Publicidade médica desejada pela farmácia',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.purple.withValues(alpha: 0.8),
                        AppColors.info.withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'DESTAQUE',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check-up Completo',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pacote com 15 exames + consulta',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ 299,90',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.purple,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text('Agendar'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 3. BUSCAR
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar médicos ou especialidades...',
                    prefixIcon: Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: isDark ? AppColors.darkCard : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Especialidades
                Row(
                  children: [
                    Text(
                      'Especialidades:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.tune, color: AppColors.primary, size: 20),
                  ],
                ),

                const SizedBox(height: 12),

                // Filtros horizontais
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Todas',
                        isSelected: _selectedEspecialidade == 'Todas',
                        onTap: () => setState(() => _selectedEspecialidade = 'Todas'),
                      ),
                      _FilterChip(
                        label: 'Clínico Geral',
                        isSelected: _selectedEspecialidade == 'Clínico Geral',
                        onTap: () => setState(() => _selectedEspecialidade = 'Clínico Geral'),
                      ),
                      _FilterChip(
                        label: 'Cardiologia',
                        isSelected: _selectedEspecialidade == 'Cardiologia',
                        onTap: () => setState(() => _selectedEspecialidade = 'Cardiologia'),
                      ),
                      _FilterChip(
                        label: 'Ginecologia',
                        isSelected: _selectedEspecialidade == 'Ginecologia',
                        onTap: () => setState(() => _selectedEspecialidade = 'Ginecologia'),
                      ),
                      _FilterChip(
                        label: 'Pediatria',
                        isSelected: _selectedEspecialidade == 'Pediatria',
                        onTap: () => setState(() => _selectedEspecialidade = 'Pediatria'),
                      ),
                      _FilterChip(
                        label: 'Dermatologia',
                        isSelected: _selectedEspecialidade == 'Dermatologia',
                        onTap: () => setState(() => _selectedEspecialidade = 'Dermatologia'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // 5. BUSCAS RECENTES
                Row(
                  children: [
                    Icon(Icons.history, color: AppColors.info, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Buscas Recentes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.clear_all, size: 16),
                      label: Text('Limpar'),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _BuscaRecenteChip(label: 'Dr. João Pediatra', isDark: isDark),
                    _BuscaRecenteChip(label: 'Cardiologista', isDark: isDark),
                    _BuscaRecenteChip(label: 'Dra. Maria', isDark: isDark),
                    _BuscaRecenteChip(label: 'Dermatologia', isDark: isDark),
                  ],
                ),

                const SizedBox(height: 40),

                // 6. MÉDICOS DISPONÍVEIS
                Text(
                  'Médicos Disponíveis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '5 médicos encontrados',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 20),

                // Lista de médicos
                _MedicoCard(
                  avatar: 'DJ',
                  nome: 'Dr. João Pediatra',
                  especialidade: 'Pediatria',
                  rating: 4.8,
                  distancia: '1,2 km',
                  clinica: 'Clínica Saúde Infantil',
                  endereco: 'Rua das Flores, 123',
                  precoOriginal: 'R\$ 200',
                  precoDesconto: 'R\$ 160',
                  desconto: '20% de desconto',
                  isTelemedicina: true,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _MedicoCard(
                  avatar: 'DA',
                  nome: 'Dra. Ana Cardiologista',
                  especialidade: 'Cardiologia',
                  rating: 4.9,
                  distancia: '0,8 km',
                  clinica: 'Centro Cardíaco',
                  endereco: 'Av. Principal, 456',
                  precoOriginal: 'R\$ 250',
                  precoDesconto: 'R\$ 200',
                  desconto: '20% de desconto',
                  isTelemedicina: false,
                  isDark: isDark,
                ),

                const SizedBox(height: 16),

                _MedicoCard(
                  avatar: 'CS',
                  nome: 'Dr. Carlos Silva',
                  especialidade: 'Clínico Geral',
                  rating: 4.7,
                  distancia: '1,5 km',
                  clinica: 'Clínica Vida',
                  endereco: 'Rua Central, 789',
                  precoOriginal: 'R\$ 180',
                  precoDesconto: 'R\$ 144',
                  desconto: '20% de desconto',
                  isTelemedicina: true,
                  isDark: isDark,
                ),

                const SizedBox(height: 40),

                // 7. NOVOS PARCEIROS
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.new_releases, color: AppColors.warning, size: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Novos Parceiros',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text('Ver todos'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  'Clínicas e especialistas novos na ClubePharma',
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
                      _MedicoCardHorizontal(
                        avatar: 'RF',
                        nome: 'Dr. Rafael Fernandes',
                        especialidade: 'Ortopedia',
                        rating: 4.9,
                        desconto: '25%',
                        isDark: isDark,
                        isNovo: true,
                      ),
                      _MedicoCardHorizontal(
                        avatar: 'LC',
                        nome: 'Dra. Lívia Costa',
                        especialidade: 'Endocrinologia',
                        rating: 4.8,
                        desconto: '20%',
                        isDark: isDark,
                        isNovo: true,
                      ),
                      _MedicoCardHorizontal(
                        avatar: 'PM',
                        nome: 'Dr. Paulo Moreira',
                        especialidade: 'Oftalmologia',
                        rating: 4.7,
                        desconto: '15%',
                        isDark: isDark,
                        isNovo: true,
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}

// Card de Consulta Agendada
class _ConsultaAgendadaCard extends StatelessWidget {
  final String medico;
  final String especialidade;
  final String data;
  final String horario;
  final String local;
  final String avatar;
  final bool isTelemedicina;
  final bool isDark;

  const _ConsultaAgendadaCard({
    required this.medico,
    required this.especialidade,
    required this.data,
    required this.horario,
    required this.local,
    required this.avatar,
    this.isTelemedicina = false,
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
          color: AppColors.accent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.accent.withValues(alpha: 0.15),
            child: Text(
              avatar,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        medico,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                    if (isTelemedicina)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.videocam, size: 12, color: AppColors.info),
                            const SizedBox(width: 4),
                            Text(
                              'Online',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.info,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  especialidade,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      '$data • $horario',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        local,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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

// Card Horizontal de Médico (Novos Parceiros)
class _MedicoCardHorizontal extends StatelessWidget {
  final String avatar;
  final String nome;
  final String especialidade;
  final double rating;
  final String desconto;
  final bool isDark;
  final bool isNovo;

  const _MedicoCardHorizontal({
    required this.avatar,
    required this.nome,
    required this.especialidade,
    required this.rating,
    required this.desconto,
    required this.isDark,
    this.isNovo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          if (isNovo)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'NOVO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ),
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              avatar,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nome,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            especialidade,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Desconto $desconto',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Chip de Busca Recente
class _BuscaRecenteChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _BuscaRecenteChip({
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history,
              size: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.info : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.info : AppColors.lightBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : AppColors.lightTextSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _MedicoCard extends StatelessWidget {
  final String avatar;
  final String nome;
  final String especialidade;
  final double rating;
  final String distancia;
  final String clinica;
  final String endereco;
  final String precoOriginal;
  final String precoDesconto;
  final String desconto;
  final bool isTelemedicina;
  final bool isDark;

  const _MedicoCard({
    required this.avatar,
    required this.nome,
    required this.especialidade,
    required this.rating,
    required this.distancia,
    required this.clinica,
    required this.endereco,
    required this.precoOriginal,
    required this.precoDesconto,
    required this.desconto,
    required this.isTelemedicina,
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
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFDEEBFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            nome,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkText : AppColors.lightText,
                            ),
                          ),
                        ),
                        if (isTelemedicina)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Telemedicina',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      especialidade,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.location_on, color: AppColors.primary, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          distancia,
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

          // Clínica
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      clinica,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      endereco,
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

          // Preço e botão
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        desconto,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text('Agendar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
