import 'package:easy_localization/easy_localization.dart';
import 'package:finalproject/core/constant/constant.dart';
import 'package:finalproject/core/services/tts_service.dart';
import 'package:flutter/material.dart';

class TtsSettingsSheet extends StatefulWidget {
  const TtsSettingsSheet({super.key});

  @override
  State<TtsSettingsSheet> createState() => _TtsSettingsSheetState();
}

class _TtsSettingsSheetState extends State<TtsSettingsSheet> {
  final TtsService _ttsService = TtsService();
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;
  String _selectedLanguage = 'en-US';

  final Map<String, String> _languages = {
    'en-US': 'English (US)',
    'vi-VN': 'Tiếng Việt',
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppTitle.textToSpeech.tr(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Language Selection
            Text(AppTitle.language.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: _languages.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLanguage = value);
                  _ttsService.setLanguage(value);
                }
              },
            ),
            const SizedBox(height: 16),

            // Speech Rate
            Text(AppTitle.speechRate.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(AppTitle.slow.tr()),
                Expanded(
                  child: Slider(
                    value: _speechRate,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: _speechRate.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _speechRate = value);
                      _ttsService.setSpeechRate(value);
                    },
                  ),
                ),
                Text(AppTitle.fast.tr()),
              ],
            ),

            // Pitch
            Text(AppTitle.pitch.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(AppTitle.low.tr()),
                Expanded(
                  child: Slider(
                    value: _pitch,
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: _pitch.toStringAsFixed(1),
                    onChanged: (value) {
                      setState(() => _pitch = value);
                      _ttsService.setPitch(value);
                    },
                  ),
                ),
                Text(AppTitle.high.tr()),
              ],
            ),

            // Volume
            Text(AppTitle.volume.tr(), style: TextStyle(fontWeight: FontWeight.w600)),
            Row(
              children: [
                const Icon(Icons.volume_down),
                Expanded(
                  child: Slider(
                    value: _volume,
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: (_volume * 100).toInt().toString(),
                    onChanged: (value) {
                      setState(() => _volume = value);
                      _ttsService.setVolume(value);
                    },
                  ),
                ),
                const Icon(Icons.volume_up),
              ],
            ),

            const SizedBox(height: 16),

            // Test Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _ttsService.speak('Hello, this is a test message', 'test');
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(AppTitle.testVoice.tr()),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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