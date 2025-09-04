import 'package:flutter/material.dart';

class GICTableWidget extends StatefulWidget {
  const GICTableWidget({super.key});

  @override
  State<GICTableWidget> createState() => _GICTableWidgetState();
}

class _GICTableWidgetState extends State<GICTableWidget> {
  List<GICPatient> _patients = [];
  List<GICPatient> _filteredPatients = [];
  String _sortColumn = 'name';
  bool _sortAscending = true;
  
  // Pagination
  int _currentPage = 1;
  int _rowsPerPage = 10;
  
  // Filter controllers
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _dobFilterController = TextEditingController();
  final TextEditingController _phoneFilterController = TextEditingController();
  String _mcoFilter = '';
  String _apptFilter = '';
  String _measureFilter = '';
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _loadSampleData();
    _applyFilters();
  }

  void _loadSampleData() {
    _patients = [
      GICPatient(
        name: 'Argentina D Baez Melo',
        mco: 'Healthfirst',
        dob: '01-31-1959',
        appointment: 'KED',
        measure: 'Completed',
        status: 'Completed',
        phone: '17189601223',
      ),
      GICPatient(
        name: 'Eliezer Feliz',
        mco: 'Anthem',
        dob: '05-15-1972',
        appointment: 'CBP',
        measure: 'Open',
        status: 'Open',
        phone: '6466448650',
      ),
      GICPatient(
        name: 'Camilo Rosario',
        mco: 'Emblem',
        dob: '03-22-1985',
        appointment: 'AWV',
        measure: 'Completed',
        status: 'Completed',
        phone: '7185551234',
      ),
      GICPatient(
        name: 'Maria Rodriguez',
        mco: 'Molina',
        dob: '07-08-1968',
        appointment: 'COL',
        measure: 'Open',
        status: 'Open',
        phone: '9178889999',
      ),
      GICPatient(
        name: 'Juan Carlos Lopez',
        mco: 'Healthfirst',
        dob: '11-14-1975',
        appointment: 'CCS',
        measure: 'Completed',
        status: 'Completed',
        phone: '6467778888',
      ),
      GICPatient(
        name: 'Ana Martinez',
        mco: 'Anthem',
        dob: '09-03-1982',
        appointment: 'PPC',
        measure: 'Open',
        status: 'Open',
        phone: '7186667777',
      ),
      GICPatient(
        name: 'Roberto Sanchez',
        mco: 'Emblem',
        dob: '02-18-1965',
        appointment: 'AWV',
        measure: 'Completed',
        status: 'Completed',
        phone: '9175556666',
      ),
      GICPatient(
        name: 'Carmen Torres',
        mco: 'Molina',
        dob: '12-25-1978',
        appointment: 'KED',
        measure: 'Open',
        status: 'Open',
        phone: '6464445555',
      ),
      GICPatient(
        name: 'Luis Gonzalez',
        mco: 'Healthfirst',
        dob: '04-07-1980',
        appointment: 'CBP',
        measure: 'Completed',
        status: 'Completed',
        phone: '7183334444',
      ),
      GICPatient(
        name: 'Isabella Silva',
        mco: 'Anthem',
        dob: '08-12-1970',
        appointment: 'COL',
        measure: 'Open',
        status: 'Open',
        phone: '9172223333',
      ),
    ];
    _filteredPatients = List.from(_patients);
  }

  void _applyFilters() {
    setState(() {
      _filteredPatients = _patients.where((patient) {
        final nameMatch = patient.name.toLowerCase().contains(_nameFilterController.text.toLowerCase());
        final mcoMatch = _mcoFilter.isEmpty || patient.mco == _mcoFilter;
        final dobMatch = patient.dob.contains(_dobFilterController.text);
        final apptMatch = _apptFilter.isEmpty || patient.appointment == _apptFilter;
        final measureMatch = _measureFilter.isEmpty || patient.measure == _measureFilter;
        final statusMatch = _statusFilter.isEmpty || patient.status == _statusFilter;
        final phoneMatch = patient.phone.contains(_phoneFilterController.text);
        
        return nameMatch && mcoMatch && dobMatch && apptMatch && measureMatch && statusMatch && phoneMatch;
      }).toList();
      _currentPage = 1; // Reset to first page when filtering
    });
  }

  List<GICPatient> get _paginatedPatients {
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return _filteredPatients.sublist(
      startIndex,
      endIndex > _filteredPatients.length ? _filteredPatients.length : endIndex,
    );
  }

  int get _totalPages => (_filteredPatients.length / _rowsPerPage).ceil();

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      setState(() {
        _currentPage = page;
      });
    }
  }

  void _sortTable(String column) {
    setState(() {
      if (_sortColumn == column) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumn = column;
        _sortAscending = true;
      }
      
      _filteredPatients.sort((a, b) {
        var aValue = _getValueForColumn(a, column);
        var bValue = _getValueForColumn(b, column);
        
        int comparison = aValue.compareTo(bValue);
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  dynamic _getValueForColumn(GICPatient patient, String column) {
    switch (column) {
      case 'name':
        return patient.name;
      case 'mco':
        return patient.mco;
      case 'dob':
        return patient.dob;
      case 'appointment':
        return patient.appointment;
      case 'measure':
        return patient.measure;
      case 'status':
        return patient.status;
      case 'phone':
        return patient.phone;
      default:
        return patient.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive sizing
        double fontSize, padding;
        if (constraints.maxWidth < 600) {
          fontSize = 11;
          padding = 6;
        } else if (constraints.maxWidth < 900) {
          fontSize = 12;
          padding = 8;
        } else {
          fontSize = 14;
          padding = 12;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Table Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: const Color(0xFFf8f9fa),
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'GIC Detailed Report',
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Export functionality - silent for now
                    },
                    icon: const Icon(Icons.file_download, size: 20),
                    tooltip: 'Export',
                  ),
                ],
              ),
            ),
            
            // Filter Row
            Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Column(
                children: [
                  // First row of filters - 2 columns for better fit
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _nameFilterController,
                          hint: 'Name...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _mcoFilter,
                          items: ['', 'Healthfirst', 'Anthem', 'Emblem', 'Molina'],
                          hint: 'MCO',
                          onChanged: (value) {
                            _mcoFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  // Second row of filters - 3 columns for better fit
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterField(
                          controller: _dobFilterController,
                          hint: 'DOB...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _apptFilter,
                          items: ['', 'KED', 'CBP', 'AWV', 'COL', 'CCS', 'PPC'],
                          hint: 'Type',
                          onChanged: (value) {
                            _apptFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _measureFilter,
                          items: ['', 'Completed', 'Open'],
                          hint: 'Measure',
                          onChanged: (value) {
                            _measureFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: padding),
                  // Third row of filters - 2 columns for remaining filters
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterDropdown(
                          value: _statusFilter,
                          items: ['', 'Completed', 'Open'],
                          hint: 'Status',
                          onChanged: (value) {
                            _statusFilter = value ?? '';
                            _applyFilters();
                          },
                        ),
                      ),
                      SizedBox(width: padding),
                      Expanded(
                        child: _buildFilterField(
                          controller: _phoneFilterController,
                          hint: 'Phone...',
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Table
            Expanded(
              child: Column(
                children: [
                  // Table with horizontal scroll
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: padding * 2,
                          dataTextStyle: TextStyle(fontSize: fontSize),
                          headingTextStyle: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF333333),
                          ),
                          columns: [
                            _buildDataColumn('NAME', 'name', fontSize),
                            _buildDataColumn('MCO', 'mco', fontSize),
                            _buildDataColumn('DOB', 'dob', fontSize),
                            _buildDataColumn('APPT', 'appointment', fontSize),
                            _buildDataColumn('MEASURE', 'measure', fontSize),
                            _buildDataColumn('STATUS', 'status', fontSize),
                            _buildDataColumn('PHONE', 'phone', fontSize),
                          ],
                          rows: _paginatedPatients.map((patient) {
                            return DataRow(
                              cells: [
                                DataCell(Text(patient.name)),
                                DataCell(Text(patient.mco)),
                                DataCell(Text(patient.dob)),
                                DataCell(Text(patient.appointment)),
                                DataCell(Text(patient.measure)),
                                DataCell(Text(patient.status)),
                                DataCell(Text(patient.phone)),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  // Pagination Controls
                  if (_totalPages > 1) ...[
                    const SizedBox(height: 16),
                    _buildPaginationControls(),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  DataColumn _buildDataColumn(String label, String column, double fontSize) {
    return DataColumn(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          SizedBox(width: 4),
          Icon(
            _sortColumn == column
                ? (_sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                : Icons.unfold_more,
            size: fontSize,
            color: Colors.grey.shade600,
          ),
        ],
      ),
      onSort: (columnIndex, ascending) => _sortTable(column),
    );
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        style: const TextStyle(fontSize: 11),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
          icon: const Icon(Icons.chevron_left),
          iconSize: 20,
        ),
        
        // Page numbers
        ...List.generate(_totalPages, (index) {
          final pageNumber = index + 1;
          final isCurrentPage = pageNumber == _currentPage;
          
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => _goToPage(pageNumber),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrentPage ? const Color(0xFF1976D2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isCurrentPage ? const Color(0xFF1976D2) : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  '$pageNumber',
                  style: TextStyle(
                    color: isCurrentPage ? Colors.white : Colors.grey.shade700,
                    fontWeight: isCurrentPage ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
        
        // Next button
        IconButton(
          onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
          icon: const Icon(Icons.chevron_right),
          iconSize: 20,
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 80), // Minimum width constraint
      child: DropdownButtonFormField<String>(
        value: value!.isEmpty ? null : value,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          isDense: true,
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item.isEmpty ? null : item,
            child: Text(
              item.isEmpty ? hint : item,
              style: TextStyle(
                fontSize: 11,
                color: item.isEmpty ? Colors.grey.shade500 : Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  @override
  void dispose() {
    _nameFilterController.dispose();
    _dobFilterController.dispose();
    _phoneFilterController.dispose();
    super.dispose();
  }
}

class GICPatient {
  final String name;
  final String mco;
  final String dob;
  final String appointment;
  final String measure;
  final String status;
  final String phone;

  GICPatient({
    required this.name,
    required this.mco,
    required this.dob,
    required this.appointment,
    required this.measure,
    required this.status,
    required this.phone,
  });
}
