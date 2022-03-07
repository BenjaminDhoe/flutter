import 'dart:async';

import 'index.dart';
import 'serializers.dart';
import 'package:built_value/built_value.dart';

part 'meditations_record.g.dart';

abstract class MeditationsRecord
    implements Built<MeditationsRecord, MeditationsRecordBuilder> {
  static Serializer<MeditationsRecord> get serializer =>
      _$meditationsRecordSerializer;

  @nullable
  @BuiltValueField(wireName: 'Date')
  DateTime get date;

  @nullable
  @BuiltValueField(wireName: 'Duration')
  String get duration;

  @nullable
  @BuiltValueField(wireName: 'Name')
  String get name;

  @nullable
  @BuiltValueField(wireName: 'Audio')
  String get audio;

  @nullable
  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference get reference;

  static void _initializeBuilder(MeditationsRecordBuilder builder) => builder
    ..duration = ''
    ..name = ''
    ..audio = '';

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('meditations');

  static Stream<MeditationsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s)));

  static Future<MeditationsRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s)));

  MeditationsRecord._();
  factory MeditationsRecord([void Function(MeditationsRecordBuilder) updates]) =
      _$MeditationsRecord;

  static MeditationsRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference});
}

Map<String, dynamic> createMeditationsRecordData({
  DateTime date,
  String duration,
  String name,
  String audio,
}) =>
    serializers.toFirestore(
        MeditationsRecord.serializer,
        MeditationsRecord((m) => m
          ..date = date
          ..duration = duration
          ..name = name
          ..audio = audio));
