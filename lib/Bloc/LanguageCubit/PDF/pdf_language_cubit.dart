// language_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class PDFLanguageCubit extends Cubit<String?> {
  PDFLanguageCubit() : super(null);

  void setLanguage(String language) {
    emit(language);
  }
}
