import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../providers/habit_provider.dart';

// ─────────────────────────────────────────────
// Data model for a chat message
// ─────────────────────────────────────────────
class _ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  _ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

// ─────────────────────────────────────────────
// Quick-prompt chips shown on empty state
// ─────────────────────────────────────────────
const List<String> _quickPrompts = [
  "Why is my energy low after lunch?",
  "Best time to drink water?",
  "How to sleep better tonight?",
  "Motivate me to stay consistent",
  "What should I eat before yoga?",
  "Why is breakfast skipping bad?",
];

// ─────────────────────────────────────────────
// AI Coach Screen
// ─────────────────────────────────────────────
class AiCoachScreen extends StatefulWidget {
  const AiCoachScreen({super.key});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _loading = false;

  // ── Replace with your actual Claude API key in production
  // ── In a real app, call your own backend — never expose keys in client code
  static const String _apiKey = 'YOUR_ANTHROPIC_API_KEY';

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _buildSystemPrompt(String habitSummary) {
    return '''You are Sattva Coach — a warm, knowledgeable wellness guide rooted in South Indian lifestyle and Ayurvedic wisdom.

Current habit progress today: $habitSummary

Your personality:
- Warm, encouraging, and culturally grounded
- Reference South Indian foods (idli, dosa, rasam, rice, sambar, kozhukattai) naturally
- Draw wisdom from Bhagavad Gita, Thirukkural, and Ayurveda when relevant
- Be concise — answers under 120 words unless asked for detail
- Use 1–2 relevant emojis per response, not more
- Never be preachy; be a friendly guide, not a lecturer

Focus areas: nutrition, hydration, sleep, morning routines, stress, digestion, energy, consistency.
Always connect advice back to the user's actual habits when possible.''';
  }

  Future<void> _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _loading) return;

    _controller.clear();
    setState(() {
      _messages.add(_ChatMessage(text: trimmed, isUser: true));
      _loading = true;
    });
    _scrollToBottom();

    // Build habit context
    final provider = context.read<HabitProvider>();
    final completed = provider.completedCount;
    final total = provider.totalCount;
    final habitSummary = '$completed of $total habits done today';

    // Build conversation history for Claude
    final List<Map<String, String>> history = _messages
        .where((m) => !m.isUser || m.text != trimmed)
        .map((m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text})
        .toList()
      ..add({'role': 'user', 'content': trimmed});

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-haiku-4-5-20251001',
          'max_tokens': 512,
          'system': _buildSystemPrompt(habitSummary),
          'messages': history,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final content = data['content'] as List<dynamic>;
        final reply = (content.first as Map<String, dynamic>)['text'] as String;

        setState(() => _messages.add(_ChatMessage(text: reply, isUser: false)));
      } else {
        setState(() => _messages.add(_ChatMessage(
          text: "Sorry, I couldn't connect right now. Please check your API key and try again. 🙏",
          isUser: false,
        )));
      }
    } catch (_) {
      setState(() => _messages.add(_ChatMessage(
        text: "Network error. Please try again. 🙏",
        isUser: false,
      )));
    } finally {
      if (mounted) setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: AppTheme.gold,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppTheme.gold.withOpacity(0.6), blurRadius: 6)],
              ),
            ),
            const SizedBox(width: 10),
            const Text("SATTVA COACH"),
          ],
        ),
        actions: [
          if (_messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, size: 20),
              tooltip: "Clear chat",
              onPressed: () => setState(() => _messages.clear()),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(),
          ),
          if (_loading) _buildTypingIndicator(),
          _buildInputBar(),
        ],
      ),
    );
  }

  // ── Empty state with quick prompts
  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Avatar
          Animate(
            effects: [FadeEffect(duration: 500.ms), ScaleEffect(duration: 500.ms)],
            child: Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppTheme.accentGlow.withOpacity(0.5), AppTheme.bg],
                ),
                border: Border.all(color: AppTheme.accent.withOpacity(0.4), width: 1.5),
              ),
              child: const Center(
                child: Text("🧘", style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Animate(
            effects: [FadeEffect(delay: 200.ms, duration: 400.ms)],
            child: Text(
              "Your Wellness Coach",
              style: GoogleFonts.cormorantGaramond(
                color: AppTheme.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Animate(
            effects: [FadeEffect(delay: 300.ms, duration: 400.ms)],
            child: Text(
              "Ask anything about your health,\nroutines, and South Indian lifestyle",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
            ),
          ),
          const SizedBox(height: 28),
          Animate(
            effects: [FadeEffect(delay: 400.ms, duration: 400.ms)],
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "SUGGESTIONS",
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  fontFamily: 'DM Mono',
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPrompts.asMap().entries.map((e) {
              return Animate(
                effects: [
                  FadeEffect(delay: (500 + e.key * 60).ms, duration: 300.ms),
                  SlideEffect(
                    begin: const Offset(0, 0.2),
                    delay: (500 + e.key * 60).ms,
                    duration: 300.ms,
                  ),
                ],
                child: GestureDetector(
                  onTap: () => _sendMessage(e.value),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Message list
  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _buildBubble(_messages[i], i),
    );
  }

  Widget _buildBubble(_ChatMessage msg, int i) {
    final bool isUser = msg.isUser;
    return Animate(
      effects: [
        FadeEffect(duration: 250.ms),
        SlideEffect(
          begin: Offset(isUser ? 0.05 : -0.05, 0),
          duration: 250.ms,
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.accentGlow.withOpacity(0.15),
                  border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                ),
                child: const Center(child: Text("🧘", style: TextStyle(fontSize: 14))),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isUser
                      ? AppTheme.accentGlow.withOpacity(0.25)
                      : AppTheme.card,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  border: Border.all(
                    color: isUser
                        ? AppTheme.accent.withOpacity(0.3)
                        : AppTheme.border,
                  ),
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(
                    color: isUser ? AppTheme.textPrimary : AppTheme.textPrimary,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            if (isUser) const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  // ── Typing indicator
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Row(
        children: [
          Container(
            width: 30, height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentGlow.withOpacity(0.15),
              border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
            ),
            child: const Center(child: Text("🧘", style: TextStyle(fontSize: 14))),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Animate(
                  onPlay: (c) => c.repeat(),
                  effects: [
                    FadeEffect(
                      delay: (i * 150).ms,
                      duration: 500.ms,
                      begin: 0.2,
                      end: 1.0,
                    ),
                    const ThenEffect(),
                    FadeEffect(duration: 500.ms, begin: 1.0, end: 0.2),
                  ],
                  child: Container(
                    width: 6, height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input bar
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: _sendMessage,
              decoration: InputDecoration(
                hintText: "Ask your coach…",
                hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                filled: true,
                fillColor: AppTheme.card,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppTheme.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppTheme.accent.withOpacity(0.5)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessage(_controller.text),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accent, AppTheme.accentGlow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGlow.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_upward_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
