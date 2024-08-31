import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.freezed.dart';
part 'api.g.dart';

const _apiKeyKey = '__api_key__';
String? _apiKey;

Future<void> initApiKey() async {
  _apiKey = await getKV(_apiKeyKey);
}

@riverpod
class ApiKey extends _$ApiKey {
  @override
  String? build() {
    return _apiKey;
  }

  Future<void> set(String value) async {
    state = value;
    await save();
  }

  Future<void> save() async {
    if (state != null) {
      await setKV(_apiKeyKey, state!);
    }
  }
}

@freezed
class GeminiModel with _$GeminiModel {
  const factory GeminiModel({
    required String model,
    required String title,
  }) = _GeminiModel;
}

const models = [
  GeminiModel(model: 'gemini-1.5-pro-exp-0827', title: '1.5 Pro (0827)'),
  GeminiModel(model: 'gemini-1.5-flash-exp-0827', title: '1.5 Flash (0827)'),
  GeminiModel(
      model: 'gemini-1.5-flash-8b-exp-0827', title: '1.5 Flash 8B (0827)'),
  GeminiModel(model: 'gemini-1.0-pro', title: '1.0 Pro'),
  GeminiModel(model: 'gemini-1.5-pro', title: '1.5 Pro'),
  GeminiModel(model: 'gemini-1.5-flash', title: '1.5 Flash'),
];

@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  GeminiModel build() => models[0];

  void setModel(GeminiModel model) {
    state = model;
  }
}

@riverpod
GenerativeModel generativeModel(GenerativeModelRef ref) {
  final apiKey = ref.watch(apiKeyProvider);
  if (apiKey == null) {
    throw Exception('API key is required');
  }
  final model = ref.watch(selectedModelProvider);
  return GenerativeModel(model: model.model, apiKey: apiKey);
}

enum WorkerState {
  idle,
  working,
}

final safetySettings = [
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
];

Stream<String>? streamingResponse;

@Riverpod(keepAlive: true)
class GeneratingResponse extends _$GeneratingResponse {
  @override
  bool build() {
    return streamingResponse != null;
  }

  void setResponse(Stream<String> response) {
    streamingResponse = response;
    state = true;
  }

  void clear() {
    streamingResponse = null;
    state = false;
  }
}

@Riverpod(keepAlive: true)
class GenerateWorker extends _$GenerateWorker {
  @override
  WorkerState build() {
    return WorkerState.idle;
  }

  Future<void> generate() async {
    if (state == WorkerState.working) {
      return;
    }
    state = WorkerState.working;
    final history = ref.read(getChatHistoryItemsProvider);
    if (history.isEmpty) {
      return;
    }
    final last = history.last;
    if (!last.isUser || last.error) {
      return;
    }
    try {
      final generativeModel = ref.read(generativeModelProvider);
      final history = ref.read(getChatHistoryItemsProvider);
      final send = List<Content>.empty(growable: true);
      //TODO: send.add(Content.system(''));
      for (final item in history) {
        if (item.error) {
          throw Exception('Error in chat history');
        }
        if (item.isUser) {
          send.add(Content.multi([
            TextPart(item.message),
            for (final file in item.files)
              DataPart(file.mimeType, (await loadFile(file.id))!),
          ]));
        } else {
          send.add(Content.model([
            TextPart(item.message),
            for (final file in item.files)
              DataPart(file.mimeType, (await loadFile(file.id))!),
          ]));
        }
      }
      final response = generativeModel.generateContentStream(send,
          safetySettings: safetySettings);
      final stream = StreamController<String>.broadcast();
      ref.read(generatingResponseProvider.notifier).setResponse(stream.stream);
      String resp = "";
      await for (final part in response) {
        final text = part.text;
        if (text != null) {
          resp += text;
          stream.add(resp);
        }
      }
      ref.read(generatingResponseProvider.notifier).clear();
      stream.close();
      ref.read(chatHistoryProvider.notifier).add(ChatHistoryItem.bot(resp));
    } catch (e) {
      ref.read(generatingResponseProvider.notifier).clear();
      ref.read(chatHistoryProvider.notifier).add(
          ChatHistoryItem.error('Error generating response: ${e.toString()}'));
    } finally {
      state = WorkerState.idle;
    }
  }
}
