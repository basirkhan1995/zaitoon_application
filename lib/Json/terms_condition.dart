import 'dart:convert';
import 'package:equatable/equatable.dart';

TermsAndCondition termsAndConditionFromMap(String str) =>
    TermsAndCondition.fromMap(json.decode(str));

String termsAndConditionToMap(TermsAndCondition data) =>
    json.encode(data.toMap());

class TermsAndCondition extends Equatable {
  final int? tcId;
  final String? termTitle;
  final String? termDescription;

  const TermsAndCondition({
    this.tcId,
    this.termTitle,
    this.termDescription,
  });

  TermsAndCondition copyWith(
          {int? tcId, String? termTitle, String? termDescription}) =>
      TermsAndCondition(
        tcId: tcId ?? this.tcId,
        termTitle: termTitle ?? this.termTitle,
        termDescription: termDescription ?? this.termDescription,
      );

  factory TermsAndCondition.fromMap(Map<String, dynamic> json) =>
      TermsAndCondition(
        tcId: json["tcId"],
        termTitle: json["termTitle"],
        termDescription: json["termDescription"],
      );

  Map<String, dynamic> toMap() => {
        "tcId": tcId,
        "termTitle": termTitle,
        "termDescription": termDescription,
      };

  @override
  List<Object?> get props => [tcId, termTitle, termDescription];
}
