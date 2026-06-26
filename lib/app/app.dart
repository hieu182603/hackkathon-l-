import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hackathon/app/routes/app_routes.dart';
import 'package:hackathon/core/network/api_client.dart';
import 'package:hackathon/features/auth/application/services/auth_service_impl.dart';
import 'package:hackathon/features/auth/application/services/i_auth_service.dart';
import 'package:hackathon/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:hackathon/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:hackathon/features/auth/data/mappers/user_mapper.dart';
import 'package:hackathon/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:hackathon/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:hackathon/features/auth/presentation/viewmodels/login_view_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(create: (_) => ApiClient.createDio()),

        Provider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSource(context.read<Dio>()),
        ),

        Provider<AuthLocalDataSource>(
          create: (_) => AuthLocalDataSource(const FlutterSecureStorage()),
        ),

        Provider<UserMapper>(create: (_) => UserMapper()),

        Provider<IAuthRepository>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
            userMapper: context.read<UserMapper>(),
          ),
        ),

        Provider<IAuthService>(
          create: (context) => AuthServiceImpl(context.read<IAuthRepository>()),
        ),

        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(context.read<IAuthService>()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Login',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        initialRoute: AppRouter.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
