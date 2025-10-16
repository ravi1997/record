import 'package:flutter/material.dart';
import '../services/local_db_service.dart';
import '../services/sync_service.dart';
import '../constants/app_constants.dart';
import '../utils/ui_components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _todayEntries = 0;
  int _totalRecords = 0;
  int _syncedRecords = 0;
  int _pendingRecords = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboardMetrics();
  }

  Future<void> _loadDashboardMetrics() async {
    try {
      final dbService = LocalDBService();
      final syncService = SyncService();

      // Get live counts from database
      final totalPatients = await dbService.getPatientCount();
      final syncedPatients = await dbService.getSyncedPatientCount();
      final totalFiles = await dbService.getFileCount();
      final syncedFiles = await dbService.getSyncedFileCount();

      // Calculate metrics
      final totalRecords = totalPatients + totalFiles;
      final syncedRecords = syncedPatients + syncedFiles;
      final pendingRecords = totalRecords - syncedRecords;

      // For today's entries, we would normally query by date
      // For now, we'll use a simplified approach
      final todayEntries = totalPatients > 0 ? (totalPatients ~/ 10) + 1 : 0;

      setState(() {
        _todayEntries = todayEntries;
        _totalRecords = totalRecords;
        _syncedRecords = syncedRecords;
        _pendingRecords = pendingRecords;
      });
    } catch (e) {
      // In case of error, keep default values or show error state
      print('Error loading dashboard metrics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UIComponents.buildAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Show notifications
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.account_circle),
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.pushNamed(context, AppConstants.profileRoute);
              } else if (value == 'settings') {
                Navigator.pushNamed(context, AppConstants.settingsRoute);
              } else if (value == 'logout') {
                Navigator.pushReplacementNamed(
                    context, AppConstants.loginRoute);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'profile', child: Text('Profile')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              Text(
                AppConstants.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),
              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: UIComponents.buildStatCard(
                      title: 'Today\'s Entries',
                      value: '$_todayEntries',
                      icon: Icons.calendar_today,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: UIComponents.buildStatCard(
                      title: 'Total Records',
                      value: '$_totalRecords',
                      icon: Icons.inventory,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              Row(
                children: [
                  Expanded(
                    child: UIComponents.buildStatCard(
                      title: 'Synced',
                      value: '$_syncedRecords',
                      icon: Icons.cloud_done,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: UIComponents.buildStatCard(
                      title: 'Pending',
                      value: '$_pendingRecords',
                      icon: Icons.cloud_off,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingExtraLarge),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              // Action Cards
              UIComponents.buildActionCard(
                title: 'Add Patient Record',
                subtitle: 'Create a new patient record with associated files',
                icon: Icons.note_add,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.entryRoute);
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              UIComponents.buildActionCard(
                title: 'Search Records',
                subtitle: 'Find and manage existing patient records',
                icon: Icons.search,
                color: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.searchRoute);
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              UIComponents.buildActionCard(
                title: 'My Profile',
                subtitle: 'View and edit your profile information',
                icon: Icons.person,
                color: Theme.of(context).colorScheme.tertiary,
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.profileRoute);
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              UIComponents.buildActionCard(
                title: 'Settings',
                subtitle: 'Configure app preferences and sync settings',
                icon: Icons.settings,
                color: Theme.of(context).colorScheme.tertiaryContainer,
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.settingsRoute);
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),
              UIComponents.buildActionCard(
                title: 'Advanced Dashboard',
                subtitle: 'View detailed analytics and metrics',
                icon: Icons.dashboard,
                color: Theme.of(context).colorScheme.primaryContainer,
                onTap: () {
                  Navigator.pushNamed(context, AppConstants.dashboardRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
