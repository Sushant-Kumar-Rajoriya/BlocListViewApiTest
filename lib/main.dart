import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app/data/repository/git_repository.dart';
import 'app/data/provider/local/sql_repository.dart';
import 'app/modules/blocs/repository_bloc/repository_bloc.dart';
import 'app/modules/blocs/repository_bloc/repository_event.dart';
import 'app/modules/blocs/sql_repository_bloc/sql_repository_bloc.dart';
import 'app/modules/blocs/sql_repository_bloc/sql_repository_event.dart';
import 'app/modules/pages/home_page/views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sqlRepository = SqlRepository();
  await sqlRepository.initDatabase();

  runApp(MyApp(sqlRepository: sqlRepository));
}

class MyApp extends StatelessWidget {
  final SqlRepository sqlRepository;

  const MyApp({super.key, required this.sqlRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RepositoryBloc(
            GitRepository(),
            sqlRepository,
          )..add(const FetchRepositories()),
        ),
        BlocProvider(
          create: (context) => SqlRepositoryBloc(
            sqlRepository,
          )..add(LoadDataFromDb()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
