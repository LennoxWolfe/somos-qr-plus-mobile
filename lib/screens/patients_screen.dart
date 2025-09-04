import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/patient_profile_modal.dart';
import '../widgets/patient_filter_modal.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  bool _isDrawerOpen = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedProvider = 'All';
  List<Patient> _patients = [];
  List<Patient> _filteredPatients = [];
  String _mcoFilter = '';
  String _providerFilter = '';
  String _dobFilter = '';
  int _currentPage = 1;
  int _rowsPerPage = 20;

  @override
  void initState() {
    super.initState();
    _initializePatients();
    _filteredPatients = _patients;
  }

  void _initializePatients() {
    _patients = [
      Patient('James Anderson', '3/15/1965', 'HealthFirst', 85, 92),
      Patient('Maria Rodriguez', '7/22/1978', 'MetroPlus', 67, 74),
      Patient('Robert Johnson', '11/30/1982', 'Fidelis Care', 91, 88),
      Patient('Sarah Williams', '4/12/1995', 'Empire BlueCross BlueShield', 78, 82),
      Patient('David Chen', '9/3/1973', 'UnitedHealthcare Community Plan', 73, 79),
      Patient('Jennifer Lopez', '2/28/1988', 'HealthFirst', 89, 95),
      Patient('Michael Davis', '6/17/1969', 'MetroPlus', 71, 68),
      Patient('Lisa Thompson', '12/5/1991', 'Fidelis Care', 94, 91),
      Patient('William Martinez', '8/9/1984', 'Empire BlueCross BlueShield', 76, 83),
      Patient('Emily Wilson', '1/14/1976', 'UnitedHealthcare Community Plan', 82, 87),
      Patient('Christopher Lee', '5/20/1993', 'HealthFirst', 88, 93),
      Patient('Amanda Brown', '10/8/1987', 'MetroPlus', 75, 81),
      Patient('Daniel Kim', '7/31/1972', 'Fidelis Care', 69, 76),
      Patient('Jessica Taylor', '3/25/1990', 'Empire BlueCross BlueShield', 86, 89),
      Patient('Kevin Patel', '11/12/1981', 'UnitedHealthcare Community Plan', 72, 77),
    ];
  }

  void _applyFilters() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        bool matchesMCO = _mcoFilter.isEmpty || _mcoFilter == 'All' || patient.mco == _mcoFilter;
        bool matchesProvider = _providerFilter.isEmpty || _providerFilter == 'All';
        bool matchesDOB = _dobFilter.isEmpty || patient.dob == _dobFilter;
        bool matchesSearch = _searchController.text.isEmpty ||
            patient.fullName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            patient.dob.contains(_searchController.text) ||
            patient.mco.toLowerCase().contains(_searchController.text.toLowerCase());
        
        return matchesMCO && matchesProvider && matchesDOB && matchesSearch;
      }).toList();
      
      _currentPage = 1;
    });
  }

  void _showPatientProfile(Patient patient) {
    showDialog(
      context: context,
      builder: (context) => PatientProfileModal(patient: patient),
    );
  }

  void _showFilterModal() {
    showDialog(
      context: context,
      builder: (context) => PatientFilterModal(
        mcoFilter: _mcoFilter,
        providerFilter: _providerFilter,
        dobFilter: _dobFilter,
        onApply: (mco, provider, dob) {
          setState(() {
            _mcoFilter = mco;
            _providerFilter = provider;
            _dobFilter = dob;
          });
          _applyFilters();
        },
      ),
    );
  }

  List<Patient> get _paginatedPatients {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  int get _totalPages => (_filteredPatients.length / _rowsPerPage).ceil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Row: Menu, Logo, Notifications, Profile
                    Row(
                      children: [
                        // Menu Button
                        IconButton(
                          onPressed: () => setState(() => _isDrawerOpen = true),
                          icon: const Icon(Icons.menu, size: 22),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.grey.shade50,
                            padding: const EdgeInsets.all(6),
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        // Logo/Title
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'SOMOS QR',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey.shade800,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  '+',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: const Color(0xFF1976D2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Notifications
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Stack(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.notifications_outlined,
                                  color: Colors.grey.shade700,
                                  size: 18,
                                ),
                                style: IconButton.styleFrom(
                                  padding: const EdgeInsets.all(4),
                                ),
                              ),
                              Positioned(
                                right: 3,
                                top: 3,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(width: 6),
                        
                        // Profile Avatar
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF667EEA).withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'JC',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Bottom Row: Provider Dropdown
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: DropdownButtonFormField<String>(
                              value: _selectedProvider,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFF1976D2), width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                hintText: 'Select Provider',
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              items: [
                                'All',
                                'Delmont Medical, PC',
                                'Provider 2',
                                'Provider 3',
                                'Provider 4',
                              ].map((provider) => DropdownMenuItem(
                                value: provider,
                                child: Text(
                                  provider,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              )).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _selectedProvider = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Page Title
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Patients',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage and view your patient information',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Search and Filter Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search patients...',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade500,
                              size: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (value) => _applyFilters(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _showFilterModal,
                        icon: Icon(
                          Icons.filter_list,
                          color: Colors.grey.shade700,
                          size: 16,
                        ),
                        tooltip: 'Filter by MCO, Provider, or DOB',
                        style: IconButton.styleFrom(
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Patients Table
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      constraints: const BoxConstraints(minWidth: 600),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                            ),
                            child: const Row(
                              children: [
                                SizedBox(width: 150, child: Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600))),
                                SizedBox(width: 100, child: Text('DOB', style: TextStyle(fontWeight: FontWeight.w600))),
                                SizedBox(width: 150, child: Text('MCO', style: TextStyle(fontWeight: FontWeight.w600))),
                                SizedBox(width: 80, child: Text('GIC', style: TextStyle(fontWeight: FontWeight.w600))),
                                SizedBox(width: 80, child: Text('RA', style: TextStyle(fontWeight: FontWeight.w600))),
                              ],
                            ),
                          ),
                          // Table Rows
                          ..._paginatedPatients.map((patient) => GestureDetector(
                            onTap: () => _showPatientProfile(patient),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 150, child: Text(patient.fullName)),
                                  SizedBox(width: 100, child: Text(patient.dob)),
                                  SizedBox(width: 150, child: Text(patient.mco)),
                                  SizedBox(width: 80, child: Text(patient.gic.toString())),
                                  SizedBox(width: 80, child: Text(patient.ra.toString())),
                                ],
                              ),
                            ),
                          )).toList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // Pagination
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    // Left side
                    Row(
                      children: [
                        Text('Rows per page: ', style: TextStyle(color: Colors.grey.shade600)),
                        DropdownButton<int>(
                          value: _rowsPerPage,
                          underline: const SizedBox(),
                          items: [20, 35, 50, 100].map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size.toString()),
                          )).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _rowsPerPage = value;
                                _currentPage = 1;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Right side
                    Row(
                      children: [
                        Text(
                          'Page $_currentPage of $_totalPages',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
                              icon: const Icon(Icons.chevron_left),
                            ),
                            IconButton(
                              onPressed: _currentPage < _totalPages ? () => setState(() => _currentPage++) : null,
                              icon: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Drawer Overlay (transparent)
          if (_isDrawerOpen)
            GestureDetector(
              onTap: () => setState(() => _isDrawerOpen = false),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          
          // Navigation Drawer
          if (_isDrawerOpen) _buildNavigationDrawer(),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
                      boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(2, 0),
              ),
            ],
        ),
        child: Column(
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: const Color(0xFF4CAF50), width: 3),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'JC',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'SOMOS QR',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w100,
                          letterSpacing: -1.2,
                        ),
                      ),
                      Text(
                        '+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Drawer Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem('Dashboard', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    context.go('/dashboard');
                  }),
                  _buildDrawerItem('Quality Score Cards', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    context.go('/quality-scorecards');
                  }),
                  _buildDrawerItem('My Schedule', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    // TODO: Navigate to schedule page
                  }),
                  _buildDrawerItem('My Patients', true, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    context.go('/patients');
                  }),
                  _buildDrawerItem('Reports', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    context.go('/reports');
                  }),
                  _buildDrawerItem('Resources', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    // TODO: Navigate to resources page
                  }),
                  const Divider(height: 1, thickness: 1),
                  _buildDrawerItem('Settings', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    context.go('/settings');
                  }),
                  _buildDrawerItem('Log Out', false, onTap: () {
                    setState(() => _isDrawerOpen = false);
                    // TODO: Implement logout
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(String title, bool isActive, {required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      tileColor: isActive ? const Color(0xFFE3F2FD) : null,
      leading: Icon(
        _getIconForTitle(title),
        color: isActive ? const Color(0xFF1976D2) : const Color(0xFF666666),
      ),
      onTap: onTap,
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Dashboard':
        return Icons.dashboard;
      case 'Quality Score Cards':
        return Icons.bar_chart;
      case 'My Schedule':
        return Icons.schedule;
      case 'My Patients':
        return Icons.people;
      case 'Reports':
        return Icons.assessment;
      case 'Resources':
        return Icons.folder;
      case 'Settings':
        return Icons.settings;
      case 'Log Out':
        return Icons.logout;
      default:
        return Icons.circle;
    }
  }
}


