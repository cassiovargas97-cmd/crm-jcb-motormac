import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import 'login_screen.dart';
import 'clientes_screen.dart';
import 'leads_screen.dart';
import 'visitas_screen.dart';
import 'propostas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> _stats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);
    
    final clientesStats = await DatabaseService.instance.getClientesStats();
    final leadsStats = await DatabaseService.instance.getLeadsStats();
    final visitasCount = await DatabaseService.instance.getVisitasCount();
    final propostasCount = await DatabaseService.instance.getPropostasCount();
    
    setState(() {
      _stats = {
        'total_clientes': clientesStats['total']!,
        'clientes_construcao': clientesStats['construcao']!,
        'clientes_agro': clientesStats['agro']!,
        'total_leads': leadsStats['total']!,
        'leads_novos': leadsStats['novos']!,
        'leads_ganhos': leadsStats['ganhos']!,
        'total_visitas': visitasCount,
        'total_propostas': propostasCount,
      };
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CRM JCB MOTORMAC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sair'),
                  content: const Text('Deseja realmente sair?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sair'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await authService.logout();
                if (!context.mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Dashboard Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFFB300),
                      const Color(0xFFFFB300).withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Olá, ${authService.currentUserName ?? "Vendedor"}!',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      _buildStatsGrid(),
                  ],
                ),
              ),
              // Menu Principal
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu Principal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildMenuCard(
                          context,
                          title: 'Clientes',
                          icon: Icons.people,
                          color: Colors.green,
                          count: _stats['total_clientes'] ?? 0,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ClientesScreen()),
                          ).then((_) => _loadDashboardData()),
                        ),
                        _buildMenuCard(
                          context,
                          title: 'Leads',
                          icon: Icons.star,
                          color: Colors.orange,
                          count: _stats['total_leads'] ?? 0,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const LeadsScreen()),
                          ).then((_) => _loadDashboardData()),
                        ),
                        _buildMenuCard(
                          context,
                          title: 'Visitas',
                          icon: Icons.location_on,
                          color: Colors.red,
                          count: _stats['total_visitas'] ?? 0,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const VisitasScreen()),
                          ).then((_) => _loadDashboardData()),
                        ),
                        _buildMenuCard(
                          context,
                          title: 'Propostas',
                          icon: Icons.description,
                          color: Colors.purple,
                          count: _stats['total_propostas'] ?? 0,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PropostasScreen()),
                          ).then((_) => _loadDashboardData()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard('Clientes', _stats['total_clientes'] ?? 0, Icons.people, Colors.blue),
        _buildStatCard('Construção', _stats['clientes_construcao'] ?? 0, Icons.construction, const Color(0xFFFF6B35)),
        _buildStatCard('Agro', _stats['clientes_agro'] ?? 0, Icons.agriculture, const Color(0xFF4CAF50)),
        _buildStatCard('Leads', _stats['total_leads'] ?? 0, Icons.star, Colors.orange),
        _buildStatCard('Visitas', _stats['total_visitas'] ?? 0, Icons.location_on, Colors.red),
        _buildStatCard('Propostas', _stats['total_propostas'] ?? 0, Icons.description, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required int count,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 48, color: color),
                if (count > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
