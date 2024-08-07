import 'package:bloc_api_call_listview/app/data/model/data_model.dart';
import '../provider/remote/dio_api_base_helper.dart';

class GitRepository {
  Future<DataModel> fetchRepositories(
      {String? date, String? sort, String? order}) async {
    final queryParameters = {
      'q': date != null ? 'created:>$date' : 'created:>2022-04-29',
      'sort': sort ?? 'stars',
      'order': order ?? 'desc',
    };

    final response = await DioApiBaseHelper.get(
      DioApiBaseHelper.searchRepositories,
      queryParameters: queryParameters,
    );
    return DataModel.fromJson(response);
  }
}
