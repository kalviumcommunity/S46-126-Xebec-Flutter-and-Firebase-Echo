import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    bool isMobile = screenWidth < 600;
    bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    bool isDesktop = screenWidth >= 1200;
    
    double horizontalPadding = isMobile ? 16.0 : (isTablet ? 32.0 : 64.0);
    double verticalPadding = isMobile ? 8.0 : 16.0;
    
    double titleFontSize = isMobile ? 24.0 : (isTablet ? 32.0 : 40.0);
    double bodyFontSize = isMobile ? 14.0 : (isTablet ? 16.0 : 18.0);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Freelance Flow',
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          if (!isMobile) ...[
            TextButton(
              onPressed: () {},
              child: const Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Projects',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          const SizedBox(width: 8),
        ],
      ),
      
      // Main Content Area
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(
                context,
                titleFontSize,
                bodyFontSize,
                isMobile,
              ),
              SizedBox(height: isMobile ? 24 : 40),
              _buildStatsCards(isMobile, isTablet),
              SizedBox(height: isMobile ? 24 : 40),
              _buildRecentProjects(
                context,
                titleFontSize,
                bodyFontSize,
                isMobile,
                isTablet,
              ),
              SizedBox(height: isMobile ? 24 : 40),
              _buildActionButtons(isMobile, isTablet),
            ],
          ),
        ),
      ),
      
      // Footer Section - Bottom Navigation for mobile, inline for desktop
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: 0,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.work),
                  label: 'Projects',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            )
          : null,
    );
  }

  // Welcome Section Widget
  Widget _buildWelcomeSection(
    BuildContext context,
    double titleFontSize,
    double bodyFontSize,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back! 👋',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Text(
            'Manage your freelance projects efficiently',
            style: TextStyle(
              fontSize: bodyFontSize,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Cards Section with Responsive Grid
  Widget _buildStatsCards(bool isMobile, bool isTablet) {
    final stats = [
      {'title': 'Active Projects', 'value': '12', 'icon': Icons.work, 'color': Colors.orange},
      {'title': 'Completed', 'value': '45', 'icon': Icons.check_circle, 'color': Colors.green},
      {'title': 'Clients', 'value': '28', 'icon': Icons.people, 'color': Colors.purple},
      {'title': 'Revenue', 'value': '\$15K', 'icon': Icons.attach_money, 'color': Colors.blue},
    ];

    // Determine grid layout based on screen size
    int crossAxisCount = isMobile ? 2 : (isTablet ? 3 : 4);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: isMobile ? 12 : 16,
            mainAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: isMobile ? 1.3 : 1.5,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              icon: stat['icon'] as IconData,
              color: stat['color'] as Color,
              isMobile: isMobile,
            );
          },
        );
      },
    );
  }

  // Individual Stat Card
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isMobile ? 32 : 40,
            color: color,
          ),
          SizedBox(height: isMobile ? 8 : 12),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 4 : 6),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Recent Projects Section
  Widget _buildRecentProjects(
    BuildContext context,
    double titleFontSize,
    double bodyFontSize,
    bool isMobile,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Projects',
          style: TextStyle(
            fontSize: titleFontSize * 0.7,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Use different layouts for mobile vs tablet/desktop
        isMobile
            ? Column(
                children: [
                  _buildProjectCard('Website Redesign', 'In Progress', Colors.blue, isMobile),
                  const SizedBox(height: 12),
                  _buildProjectCard('Mobile App UI', 'Review', Colors.orange, isMobile),
                  const SizedBox(height: 12),
                  _buildProjectCard('Logo Design', 'Completed', Colors.green, isMobile),
                ],
              )
            : Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - (isTablet ? 96 : 192)) / 2,
                    child: _buildProjectCard('Website Redesign', 'In Progress', Colors.blue, isMobile),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - (isTablet ? 96 : 192)) / 2,
                    child: _buildProjectCard('Mobile App UI', 'Review', Colors.orange, isMobile),
                  ),
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - (isTablet ? 96 : 192)) / 2,
                    child: _buildProjectCard('Logo Design', 'Completed', Colors.green, isMobile),
                  ),
                ],
              ),
      ],
    );
  }

  // Individual Project Card
  Widget _buildProjectCard(
    String title,
    String status,
    Color statusColor,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: isMobile ? 16 : 20,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons(bool isMobile, bool isTablet) {
    return isMobile
        ? Column(
            children: [
              _buildButton('Create New Project', Icons.add, Colors.blue, true),
              const SizedBox(height: 12),
              _buildButton('View All Projects', Icons.list, Colors.grey, false),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: _buildButton('Create New Project', Icons.add, Colors.blue, true),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildButton('View All Projects', Icons.list, Colors.grey, false),
              ),
            ],
          );
  }

  // Individual Button Widget
  Widget _buildButton(String text, IconData icon, Color color, bool isPrimary) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: isPrimary ? Colors.white : color),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: TextStyle(
            color: isPrimary ? Colors.white : color,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? color : color.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
