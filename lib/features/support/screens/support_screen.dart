import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import '../../../core/config/app_theme.dart';
import '../../../core/utils/app_localizations.dart';
import '../providers/chat_providers.dart';
import '../models/company_chat_message.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _shouldScrollToBottom = true;
  bool _isInitialized = false;
  double? _previousMaxScrollExtent;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    final nearBottom = pos.pixels >= pos.maxScrollExtent - 200;
    final nearTop = pos.pixels <= pos.minScrollExtent + 100;

    // If the user scrolls up, we stop auto-scrolling to the bottom
    if (nearBottom != _shouldScrollToBottom) {
      setState(() => _shouldScrollToBottom = nearBottom);
    }

    // Pagination logic
    final chatState = ref.read(chatProvider);
    if (nearTop &&
        chatState.hasMorePages &&
        !chatState.isLoadingMore &&
        _isInitialized) {
      _previousMaxScrollExtent = pos.maxScrollExtent;
      ref.read(chatProvider.notifier).loadMoreMessages().then((_) {
        _adjustScrollAfterLoadMore();
      });
    }
  }

  void _adjustScrollAfterLoadMore() {
    if (_previousMaxScrollExtent == null) return;

    // After loading more, the list expands at the top.
    // We jump to the difference to keep the user's view stable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final newMax = _scrollController.position.maxScrollExtent;
        final addedHeight = newMax - _previousMaxScrollExtent!;
        if (addedHeight > 0) {
          _scrollController.jumpTo(_scrollController.offset + addedHeight);
        }
        _previousMaxScrollExtent = null;
      }
    });
  }

  void _scrollToBottom({bool animate = true}) {
    if (!_scrollController.hasClients) return;

    final target = _scrollController.position.maxScrollExtent;
    if (animate) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(target);
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    try {
      await ref.read(chatProvider.notifier).sendMessage(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).failedToSendMessage)));
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) =>
      d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;

  Widget _buildDateHeader(DateTime date) {
    final loc = AppLocalizations.of(context);
    String label;
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      label = loc.today;
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      label = loc.yesterday;
    } else {
      label = intl.DateFormat('d MMMM yyyy', 'ar').format(date);
    }

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);

    // Watch for state changes to handle scrolling
    ref.listen(chatProvider, (previous, next) {
      // Handle initial load completion
      if (previous?.isLoading == true && next.isLoading == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(animate: false);
          setState(() => _isInitialized = true);
        });
      }

      // Handle new incoming messages
      if (previous != null && next.messages.length > previous.messages.length) {
        final isNewest = next.messages.last.id != previous.messages.last.id;
        if (isNewest && _shouldScrollToBottom) {
          _scrollToBottom(animate: true);
        }
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(AppLocalizations.of(context).supportTitle, style: const TextStyle(fontSize: 18)),
        centerTitle: true,
      ),
      body:
          chatState.isLoading
              ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          chatState.messages.length +
                          (chatState.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (chatState.isLoadingMore && index == 0) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        final msgIndex =
                            chatState.isLoadingMore ? index - 1 : index;
                        final msg = chatState.messages[msgIndex];

                        // Check if we need to show a date header
                        bool showHeader =
                            msgIndex == 0 ||
                            !_isSameDay(
                              msg.createdAt,
                              chatState.messages[msgIndex - 1].createdAt,
                            );

                        return Column(
                          children: [
                            if (showHeader) _buildDateHeader(msg.createdAt),
                            _MessageBubble(
                              message: msg,
                              isSupport:
                                  msg.senderType == SenderType.superAdmin,
                              time: intl.DateFormat(
                                'HH:mm',
                                'ar',
                              ).format(msg.createdAt),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildInputBar(chatState.isSendingMessage),
                ],
              ),
    );
  }

  Widget _buildInputBar(bool isSending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                textDirection: TextDirection.rtl,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).typeYourMessage,
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF7F9FC),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Material(
              color:
                  isSending
                      ? AppColors.primary.withOpacity(0.5)
                      : AppColors.primary,
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: isSending ? null : _sendMessage,
                borderRadius: BorderRadius.circular(28),
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  child:
                      isSending
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final CompanyChatMessage message;
  final bool isSupport;
  final String time;

  const _MessageBubble({
    required this.message,
    required this.isSupport,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSupport ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSupport ? const Color(0xFFE4E6EB) : AppColors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSupport ? 0 : 16),
            bottomRight: Radius.circular(isSupport ? 16 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isSupport ? Colors.black87 : Colors.white,
                fontSize: 14,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 9,
                color: isSupport ? Colors.grey.shade600 : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
