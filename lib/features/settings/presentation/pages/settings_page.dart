import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      color: Theme.of(context).primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Người dùng',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Quản lý chi tiêu cá nhân',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // App Settings
          const Text(
            'Cài đặt ứng dụng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsItem(
            icon: FontAwesomeIcons.palette,
            title: 'Giao diện',
            subtitle: 'Thay đổi theme và màu sắc',
            onTap: () {
              // TODO: Implement theme settings
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.bell,
            title: 'Thông báo',
            subtitle: 'Cài đặt nhắc nhở và thông báo',
            onTap: () {
              // TODO: Implement notification settings
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.language,
            title: 'Ngôn ngữ',
            subtitle: 'Tiếng Việt',
            onTap: () {
              // TODO: Implement language settings
            },
          ),

          const SizedBox(height: 20),

          // Data Management
          const Text(
            'Quản lý dữ liệu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsItem(
            icon: FontAwesomeIcons.download,
            title: 'Xuất dữ liệu',
            subtitle: 'Sao lưu dữ liệu chi tiêu',
            onTap: () {
              // TODO: Implement export data
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.upload,
            title: 'Nhập dữ liệu',
            subtitle: 'Khôi phục từ file sao lưu',
            onTap: () {
              // TODO: Implement import data
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.trashCan,
            title: 'Xóa tất cả dữ liệu',
            subtitle: 'Xóa toàn bộ chi tiêu đã lưu',
            onTap: () {
              _showDeleteAllDataDialog(context);
            },
            isDestructive: true,
          ),

          const SizedBox(height: 20),

          // About Section
          const Text(
            'Thông tin',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),

          _buildSettingsItem(
            icon: FontAwesomeIcons.circleInfo,
            title: 'Về ứng dụng',
            subtitle: 'Phiên bản 1.0.0',
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.heart,
            title: 'Đánh giá ứng dụng',
            subtitle: 'Giúp chúng tôi cải thiện ứng dụng',
            onTap: () {
              // TODO: Implement app rating
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (isDestructive ? Colors.red : Colors.blue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FaIcon(
            icon,
            color: isDestructive ? Colors.red : Colors.blue,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDestructive ? Colors.red : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: FaIcon(
          FontAwesomeIcons.chevronRight,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _showDeleteAllDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa tất cả dữ liệu'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa tất cả dữ liệu chi tiêu? Hành động này không thể hoàn tác.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement delete all data
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tính năng sẽ được cập nhật trong phiên bản tiếp theo'),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Expense Tracker',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FaIcon(
          FontAwesomeIcons.wallet,
          color: Theme.of(context).primaryColor,
          size: 32,
        ),
      ),
      children: const [
        Text(
          'Ứng dụng quản lý chi tiêu cá nhân được phát triển với Flutter và Clean Architecture.',
        ),
      ],
    );
  }
}