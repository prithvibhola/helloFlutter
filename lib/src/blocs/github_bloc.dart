import '../resources/repository/github_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/models.dart';

class GithubBloc {
  final gitRepo = GithubRepository();
  final subject = PublishSubject<GithubUser>();

  Observable<GithubUser> get gitUsers => subject.stream;

  getGithubUsers(String query) async {
    GithubUser itemModel = await gitRepo.getGithubUsers(query);
    subject.sink.add(itemModel);
  }

  dispose() {
    subject.close();
  }
}

final bloc = GithubBloc();
