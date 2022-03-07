import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'meditation_record.g.dart';

abstract class MeditationRecord
    implements Built<MeditationRecord, MeditationRecordBuilder> {
  static Serializer<MeditationRecord> get serializer =>
      _$meditationRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'Duration')
  String get duration;

  @nullable
  @BuiltValueField(wireName: 'Name')
  String get name;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(MeditationRecordBuilder builder) => builder
    ..duration = ''
    ..name = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Meditation');

  static Stream<MeditationRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<MeditationRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  MeditationRecord._();
  factory MeditationRecord([void Function(MeditationRecordBuilder) updates]) =
      _$MeditationRecord;

  static MeditationRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createMeditationRecordData({
  String duration,
  String name,
}) =>
    serializers.toFirestore(
        MeditationRecord.serializer,
        MeditationRecord((m) => m
          ..duration = duration
          ..name = name));
