import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gemini_gui/chat/state.dart';
import 'package:gemini_gui/db/db.dart';
import 'package:gemini_gui/db/file.dart';
import 'package:gemini_gui/project/data.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
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

const _chatCustomInstructionKey = '__chat_custom_instruction__';

@riverpod
class ChatInstruction extends _$ChatInstruction {
  @override
  Future<String> build() async {
    return await getKV(_chatCustomInstructionKey) ?? '';
  }

  Future<void> set(String value) async {
    state = AsyncData(value);
    await save();
  }

  Future<void> save() async {
    await setKV(_chatCustomInstructionKey, await future);
  }
}

@freezed
class GeminiModel with _$GeminiModel {
  const factory GeminiModel({
    required String model,
    required String title,
  }) = _GeminiModel;

  factory GeminiModel.fromJson(Map<String, dynamic> json) =>
      _$GeminiModelFromJson(json);
}

const _models = [
  GeminiModel(model: 'gemini-1.5-pro-002', title: '1.5 Pro (002)'),
  GeminiModel(model: 'gemini-1.5-flash-002', title: '1.5 Flash (002)'),
  GeminiModel(model: 'gemini-1.5-pro-exp-0827', title: '1.5 Pro (0827)'),
  GeminiModel(model: 'gemini-1.5-flash-exp-0827', title: '1.5 Flash (0827)'),
  GeminiModel(
      model: 'gemini-1.5-flash-8b-exp-0827', title: '1.5 Flash 8B (0827)'),
  GeminiModel(model: 'gemini-1.0-pro', title: '1.0 Pro'),
  GeminiModel(model: 'gemini-1.5-pro', title: '1.5 Pro'),
  GeminiModel(model: 'gemini-1.5-flash', title: '1.5 Flash'),
];

const modelsURL = "https://gemini.hiro.red";
const modelsKey = '__models__';

@freezed
class ModelsData with _$ModelsData {
  const factory ModelsData({
    required List<GeminiModel> models,
    required String lastUpdate,
  }) = _ModelsData;

  factory ModelsData.fromJson(Map<String, dynamic> json) =>
      _$ModelsDataFromJson(json);
}

@riverpod
class Models extends _$Models {
  @override
  List<GeminiModel> build() {
    Future(load);
    return _models;
  }

  Future<void> load() async {
    final data = await getKV(modelsKey);
    if (data != null) {
      final models = ModelsData.fromJson(jsonDecode(data));
      state = models.models;
      if (DateTime.now().difference(DateTime.parse(models.lastUpdate)).inHours <
          12) {
        return;
      }
    }
    try {
      final response = await http.get(Uri.parse('$modelsURL/models.json'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as List<dynamic>;
        final models = json.map((e) => GeminiModel.fromJson(e)).toList();
        state = models;
        await save();
      }
    } catch (e) {
      debugPrint('Error loading models: $e');
    }
  }

  Future<void> save() async {
    final data =
        ModelsData(models: state, lastUpdate: DateTime.now().toIso8601String());
    await setKV(modelsKey, jsonEncode(data.toJson()));
  }
}

@riverpod
class SelectedModel extends _$SelectedModel {
  @override
  GeminiModel build() {
    final models = ref.watch(modelsProvider);
    return models.first;
  }

  void setModel(GeminiModel model) {
    state = model;
  }
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
      final apiKey = ref.read(apiKeyProvider);
      if (apiKey == null) {
        throw Exception('API key is required');
      }
      final model = ref.read(selectedModelProvider);
      final select = ref.read(selectedProjectProvider);
      Content? content;
      final attachment = List<Part>.empty(growable: true);
      if (select != null) {
        final text = await loadProject(select);
        final data = ProjectData.fromJson(jsonDecode(text!));
        final con = [
          if (data.customInstruction.isNotEmpty)
            TextPart(data.customInstruction),
        ];
        if (data.customInstruction.isNotEmpty) {
          content = Content(
            'system',
            con,
          );
        }
        if (data.files.isNotEmpty) {
          for (final file in data.files) {
            if (file.mimeType == 'directory') {
              final name = utf8.decode((await loadFile(file.id))!);
              final dir = Directory(name);
              final dirParts = await dirToChatPart(dir);
              attachment.addAll(dirParts);
              continue;
            }
            final head =
                TextPart('Attachment(Reference materials): ${file.name}');
            final data = DataPart(file.mimeType, (await loadFile(file.id))!);
            attachment.add(head);
            attachment.add(data);
          }
        }
      } else {
        final text = await ref.read(chatInstructionProvider.future);
        if (text.isNotEmpty) content = Content.system(text);
      }
      final send = List<Content>.empty(growable: true);
      final generativeModel = GenerativeModel(
          model: model.model, apiKey: apiKey, systemInstruction: content);
      {
        final item = history.first;
        if (!item.isUser) {
          throw Exception('Error in chat history');
        }
        send.add(Content.multi([
          ...attachment,
          TextPart(item.message),
          for (final file in item.files) ...[
            TextPart('Attachment: ${file.name}'),
            DataPart(file.mimeType, (await loadFile(file.id))!)
          ],
        ]));
      }
      for (final item in history.skip(1)) {
        if (item.error) {
          throw Exception('Error in chat history');
        }
        if (item.isUser) {
          send.add(Content.multi([
            TextPart(item.message),
            for (final file in item.files) ...[
              TextPart('Attachment: ${file.name}'),
              DataPart(file.mimeType, (await loadFile(file.id))!)
            ],
          ]));
        } else {
          send.add(Content.model([
            TextPart(item.message),
            for (final file in item.files) ...[
              TextPart('Attachment: ${file.name}'),
              DataPart(file.mimeType, (await loadFile(file.id))!)
            ],
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
