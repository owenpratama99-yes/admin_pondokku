import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/manager_scaffold.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ManagerScaffold(
      title: 'Chat',
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildChatList(),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search chats...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              _buildChatItem('Dago Branch', 'Manager: Meeting jam 3 sore', '10:30', 2),
              _buildChatItem('Dipatiukur Branch', 'Rudi: Siap pak', '09:15', 0),
              _buildChatItem('All Staff', 'Owner: Libur tanggal 17', 'Yesterday', 5),
              _buildChatItem('Pasteur Branch', 'Siti: Stock kopi habis', 'Yesterday', 0),
              _buildChatItem('Cihampelas Branch', 'Ahmad: Terima kasih', '2 days ago', 0),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatItem(String name, String lastMessage, String time, int unread) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.primarySurface,
        child: Text(
          name.substring(0, 1),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      title: Text(
        name,
        style: GoogleFonts.outfit(
          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.outfit(fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textMuted),
          ),
          if (unread > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$unread',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.textMuted),
          const SizedBox(height: 16),
          Text(
            'Pilih chat untuk memulai',
            style: GoogleFonts.outfit(fontSize: 16, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
