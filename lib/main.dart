import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/data_sources/local/audio_note_local_data_source.dart';
import 'data/repositories/audio_note_repository_impl.dart';
import 'presentation/bloc/audio_note_cubit.dart';
import 'presentation/pages/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Dependency Injection setup (Simplified for this example)
  final localDataSource = AudioNoteLocalDataSourceImpl();
  final repository = AudioNoteRepositoryImpl(localDataSource: localDataSource);

  runApp(EchoSpaceApp(repository: repository));
}

class EchoSpaceApp extends StatelessWidget {
  final AudioNoteRepositoryImpl repository;

  const EchoSpaceApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioNoteCubit(repository: repository),
      child: MaterialApp(
        title: 'EchoSpace',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF6366F1), // Soft Indigo
          scaffoldBackgroundColor: const Color(0xFF0F172A), // Cosmic Blue
        ),
        home: const HomePage(),
      ),
    );
  }
}