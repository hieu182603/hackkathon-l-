import 'package:flutter/material.dart';
import 'package:hackathon/app/routers/app_router.dart';
import 'package:hackathon/features/application/services/impls/auth_service_impl.dart';
import 'package:hackathon/features/application/services/interfaces/i_auth_service.dart';
import 'package:hackathon/features/data/repositories/auth_repository_impl.dart';
import 'package:hackathon/features/domain/repositories/i_auth_repository.dart';
import 'package:hackathon/features/presentation/viewmodel/login_view_model.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Repository
        Provider<IAuthRepository>(
          create: (_) => AuthRepositoryImpl(),
        ),
        // Service
        Provider<IAuthService>(
          create: (context) => AuthServiceImpl(
            context.read<IAuthRepository>(),
          ),
        ),
        // ViewModel
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            context.read<IAuthService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Student Task Manager App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.indigo,
          ),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
